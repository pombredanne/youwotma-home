#!/usr/bin/env python
# -*- coding: utf-8 -*-

maximumHeight = 512 # maximum window height - window will grow with number of files, but will never pass this value
maxConnections = 2 # max number of concurrent uploads
showNotifications = True # True / False

#    Copyright (C) <2009>  <Sebastian Kacprzak> <naicik |at| gmail |dot| com>
#    Partial copyright <Balazs Nagy> <nxbalazs |at| gmail |dot| com> (few lines from his drop2imageshack plasma)

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.


def importErrorDialog(txt):
    try: # try to show tkinker dialog
        import Tkinter
        master = Tkinter.Tk()
        w = Tkinter.Message(master, text=txt)
        w.pack()
        Tkinter.mainloop()
    except ImportError:
        from os import system
        zenityNotInstalled = system("command -v zenity")
        if not zenityNotInstalled: #sorry for double negation
            system("zenity --info --text='" + txt + "'")
        else:
            system("xterm -hold -geometry 150x1 -bg red -T '" + txt + "' -e true")
    import sys
    sys.exit()
try:
    import pygtk
    pygtk.require('2.0') # comboboxes needs pygtk 2.4 or higher, however they work fine with package 2.14.1-1ubuntu1 - probably version number differs..
    import gtk
except ImportError:
    importErrorDialog("Este script necesita gtk y pygtk 2.0 o superior")
except AssertionError:
    importErrorDialog("Este script necesita pygtk 2.0 o superior")
try:
    import pycurl
except ImportError:
    importErrorDialog("Este script necesita pycurl. Trate de instalar el paquete python-pycurl")
from StringIO import StringIO
#from re import search
from thread import start_new_thread
from threading import BoundedSemaphore, Lock
from gobject import GError
from xml.dom import minidom

def correctExtension(file):
    return True

def copyToClipBoard(widget, text):
    display = gtk.gdk.display_manager_get().get_default_display()
    clipboard = gtk.Clipboard(display, "CLIPBOARD")#"PRIMARY"
    clipboard.set_text(text)

def showDialog(parrent, description, title='Image uploaded'):
        parrent.dialog = gtk.MessageDialog(
             parent         = None,
             flags          = gtk.DIALOG_DESTROY_WITH_PARENT,
             type           = gtk.MESSAGE_INFO,
             buttons        = gtk.BUTTONS_CLOSE,
             message_format = description
          )
        parrent.dialog.set_title(title)
        parrent.dialog.run()
        parrent.dialog.destroy()

class SendToImageshack():

    def __init__(self,mw,fileNumber):
        self.mw = mw
        self.fileNumber = fileNumber

    def progress(self, download_t, download_d, upload_t, upload_d):
        """Callback function invoked when download/upload has progress."""
        if upload_t == 0:
          return 0
        prog = upload_d / upload_t
        try: # rather not needed
            gtk.gdk.threads_enter()
            self.mw.pbars[self.fileNumber].set_fraction(prog)
            if prog < 1:
                self.mw.pbars[self.fileNumber].set_text(str(upload_d) + " / " + str(upload_t))
            else:
                self.mw.pbars[self.fileNumber].set_text("Por favor espere")
        finally:
            gtk.gdk.threads_leave()

    def parseXML(self, xml):
        """parse given xml
        returns dictionary with keys: IM, Forum, Alt Forum, HTML, Direct, Forum Thumb, Alt Forum Thumb, HTML Thumb, Twitter Link"""
        
        xmldoc = minidom.parse(StringIO(xml))
        
        correcto = xmldoc.getElementsByTagName("rsp")[0].getAttribute("stat") == 'ok'
        
        print(correcto)
        
        if not correcto:
            err = xmldoc.getElementsByTagName("err")[0]
            code = err.getAttribute("code")
            msg = err.getAttribute("msg")
            showDialog(self.mw, "Error: " + msg + " (" + code + ")"   , "Error")
            return
        
        print(xmldoc.getElementsByTagName("mediaurl")[0].firstChild.data)
        
        links = {"IM":xmldoc.getElementsByTagName("mediaurl")[0].firstChild.data}
        
        return links


    def upload(self, file, semaphore):
        if not correctExtension(file): # usually this check is not needed, but it can help later in other script
            showDialog(self.mw, "Invalid file extension\nYou can upload only "+ str(acceptImageExtensions), "Invalid file extension")
            return
        curl = pycurl.Curl()

        curl.setopt(pycurl.URL, "http://twitpic.com/api/upload")
        curl.setopt(pycurl.HTTPHEADER, ["Except:"])
        curl.setopt(pycurl.POST, 1)
        curl.setopt(pycurl.HTTPPOST, [('media', (pycurl.FORM_FILE, file)), ('username', user), ('password',pas)])

        buf = StringIO()
        curl.setopt(pycurl.WRITEFUNCTION, buf.write)
        curl.setopt(curl.NOPROGRESS, 0)
        curl.setopt(curl.PROGRESSFUNCTION, self.progress)

        semaphore.acquire()
        try:
            curl.perform()
        except pycurl.error:
            semaphore.release()
            self.showDialog(self.mw,
            """Upload unsuccessful :(
Few possible reasons:
-transmission error occured
-server is down
-your connection is down
-server didn't like your image(to big/wrong file type etc..)
-server blocked connection because of too many attempts.

Please try again later. If the problem still occur try sending file manually by website.""", "Upload unsuccessful")
            return
        semaphore.release()
        
        links = self.parseXML(buf.getvalue().strip()) # sometimes there are leading witespace in stream and minidom don't like them
        self.mw.fileUploaded(self.fileNumber, links)


class MainWindow:
    pbars = []
    comboBoxes = []
    links = []
    uploadsCompleted = 0
    uploadsCompletedLock = Lock()
    linksNames = ['IM']

    def destroy(self, widget, data=None):
        """Called before quiting"""
        gtk.main_quit()

    def fileUploaded(self, fileNumber, imageLinks):
        self.links[fileNumber] = imageLinks # there is one thread per file so this should be thread safe
        self.uploadsCompletedLock.acquire()
        try: #rather not needed
            self.uploadsCompleted += 1
        finally:
            self.uploadsCompletedLock.release()        
        try:
            gtk.gdk.threads_enter()
            self.pbars[fileNumber].set_text("subida terminada")
            self.comboBoxes[fileNumber].show()
            if(self.uploadsCompleted == len(self.comboBoxes)):
                if showNotifications:
                    try:
                        import pynotify
                        if pynotify.init("sendToImageshack"):
                            notification = pynotify.Notification("Todos los archivos fueron subidos","Haz clic en los botones para copiar el enlace al portapapeles","go-up")
                            notification.show()
                    except ImportError: pass
        finally:
            gtk.gdk.threads_leave()


    def copyAllLinks(self, widget):
        allLinks = ''
        for link in self.links:
            if link:
                allLinks += link["IM"]  + "\n" # to lazy for .join ;p
        copyToClipBoard(None, allLinks)

    def copyLink(self, widget, fileNumber):
        copyToClipBoard(None, self.links[fileNumber]['IM'])
        self.pbars[fileNumber].set_text("copiado al portapapeles") #somehow don't want to work with gtk lock, but works without it, no thread read from pbars so that shouldn't be important


    def addFiles(self, files, vbox):
        """adds progressbar, buttons and image for each file to GUI. Returns list of files with correct extension"""
        correctFiles = []
        for file in files:
            if not correctExtension(file):
                showDialog(self, "Tipo de extension invalida en el archivo: " + file + "\nSe pueden subir solo "+ str(acceptImageExtensions) + "\nSe omite el archivo.", "Extension invalida de archivo")
                continue

            hbox = gtk.HBox(False, 0)
            vbox.pack_start(hbox, False, False, 0)
            hbox.show()

            vboxSmall = gtk.VBox(False, 0)
            hbox.pack_start(vboxSmall, False, False, 0)
            vboxSmall.show()

            label = gtk.Label(file.split('/')[-1])
            vboxSmall.pack_start(label, False, False, 0)
            label.show()

            pbar = gtk.ProgressBar()
            self.pbars.append(pbar)
            vboxSmall.pack_start(pbar, False, False, 0)
            pbar.show()

            tton = gtk.Button("Copiar al portapapeles")
            self.links.append([])
            tton.connect("clicked", self.copyLink, len(correctFiles))
            tton.show()#"show" comboboxes to make windows size calculation precise(comboboxes will be hidden again before window will be desplayed)
            self.comboBoxes.append(tton)
            
            vboxSmall.pack_start(tton, False, False, 0)
            thumbnailSize = 50
            image = gtk.Image()
            original_pixbuf = gtk.gdk.pixbuf_new_from_file(file)
            ratio = float(original_pixbuf.get_width()) / original_pixbuf.get_height()
            thumbnailSizeX = thumbnailSize
            thumbnailSizeY = thumbnailSize
            if ratio > 1:
                thumbnailSizeY /= ratio
            else:
                thumbnailSizeX *= ratio
            pixbuf_zoomed = original_pixbuf.scale_simple(int(thumbnailSizeX), int(thumbnailSizeY), gtk.gdk.INTERP_BILINEAR)
            image.set_from_pixbuf(pixbuf_zoomed)
            hbox.pack_start(image, False, False, 8)
            image.show()

            separator = gtk.HSeparator()
            vbox.pack_start(separator, False, False, 4)
            separator.show()

            correctFiles.append(file)

        if not correctFiles:
            import sys
            sys.exit()
        return correctFiles

    def setWindowSize(self, vboxMainSize):
        windowSize = self.window.size_request()
        width = windowSize[0]
        if width < vboxMainSize[0]:
            width = vboxMainSize[0]
        heigh = vboxMainSize[1] + 8#error margin;)
        if maximumHeight < heigh:
            heigh = maximumHeight

        self.window.set_size_request(width+4,heigh)

    def __init__(self,files):
        self.window = gtk.Window(gtk.WINDOW_TOPLEVEL)
        self.window.set_resizable(True)

        self.window.connect("destroy", self.destroy)
        self.window.set_title("sendToImageshack")
        self.window.set_border_width(0)

        scroll = gtk.ScrolledWindow()
        scroll.set_policy(gtk.POLICY_NEVER, gtk.POLICY_AUTOMATIC)
        self.window.add(scroll)
        scroll.show()

        align = gtk.Alignment(0.5, 0.0, 0, 0)
        scroll.add_with_viewport(align)
        align.show()

        vboxMain = gtk.VBox(False, 0)
        align.add(vboxMain)
        vboxMain.show()

        correctFiles = self.addFiles(files, vboxMain)
        
        align = gtk.Alignment(0.5, 0.5, 0, 0)
        vboxMain.pack_start(align, False, False, 0)
        align.show()

        hbox = gtk.HBox(False, 5)
        hbox.set_border_width(10)
        align.add(hbox)
        hbox.show()

        if len(correctFiles) > 1:
            vbox = gtk.VBox(False, 0)
            hbox.pack_start(vbox, False, False, 0)

            vbox.show()
            bu = gtk.Button("Copiar todos los archivos")
            bu.connect("clicked", self.copyAllLinks)
            vbox.pack_start(bu, False, False, 0)
            bu.show()

        button = gtk.Button("Cerrar")
        button.connect("clicked", self.destroy)
        hbox.pack_start(button, False, False, 2)
        button.show()
        
        self.setWindowSize(vboxMain.size_request())
        for combo in self.comboBoxes: #hide comboboxes, they will be displayed when links are ready
            combo.hide()

        self.window.add_events(gtk.gdk.BUTTON_PRESS_MASK)
        self.window.show()

        i = 0
        semaphore = BoundedSemaphore(maxConnections)
        for file in correctFiles:
            sti = SendToImageshack(self,i)
            i += 1
            start_new_thread(sti.upload, (file,semaphore))


def uploadFiles(files):
    """sends files given by paths, separated by new lines"""
    gtk.gdk.threads_init()
    mw = MainWindow(files)
    gtk.main()


def responseToDialog(entry, dialog, response):
	dialog.response(response)
def userpassDialog(du,dp):
	#base this on a message dialog
	dialog = gtk.MessageDialog(
		None,
		gtk.DIALOG_MODAL | gtk.DIALOG_DESTROY_WITH_PARENT,
		gtk.MESSAGE_QUESTION,
		gtk.BUTTONS_OK,
		None)
	dialog.set_markup('Introduce tu <b>usuario</b> y <b>contraseña</b>:')
	entry = gtk.Entry()
        entry.set_text(du)
        passw = gtk.Entry()
        passw.set_text(dp)
        passw.set_visibility(False)
        entry.connect("activate", responseToDialog, dialog, gtk.RESPONSE_OK)
        passw.connect("activate", responseToDialog, dialog, gtk.RESPONSE_OK)
	
        cb = gtk.CheckButton("¿Guardar el usuario y contraseña en el anillo de clabes de gnome?");
        
	hbox = gtk.HBox()
	hbox.pack_start(gtk.Label("Usuario:"), False, 5, 5)
	hbox.pack_end(entry)
        
	hbox2 = gtk.HBox()
	hbox2.pack_start(gtk.Label("Contraseña:"), False, 5, 5)
	hbox2.pack_end(passw)
        
        hbox3 = gtk.HBox()
	hbox3.pack_start(cb, False, 5, 5)
	#some secondary text
	dialog.format_secondary_markup("Seran usados para identificarte en twitPic. El script <b>no</b> twiteara nada")
	#add it and show it
        dialog.vbox.pack_end(hbox3, True, True, 0)
        dialog.vbox.pack_end(hbox2, True, True, 0)
	dialog.vbox.pack_end(hbox, True, True, 0)
	dialog.show_all()
	#go go go
	dialog.run()
	user = entry.get_text()
        pw = passw.get_text()
        
	dialog.destroy()
	return {"user":user,"pass":pw,"store":cb.get_active()}


#defa = {"user":"","pass":"","c":False}
#try:
###    import gnomekeyring as gkey
#    items = gkey.find_items_sync(gkey.ITEM_NETWORK_PASSWORD, {"server": 'twitter.com', "protocol": 'http'})
#    if len(items) > 0:
#        item = items[0]
#        defa = {"user":item.attributes["user"],"pass":item.secret,"c":True}
#except gkey.DeniedError:
#    print('error')
#except gkey.NoMatchError:
#    print("No esta en el anillo de clabes")
#except ImportError:
#    print('gnomekeyring no disponible')

#res = userpassDialog(defa['user'],defa['pass'])

#if res['store']:
#    try:
#        import gnomekeyring as gkey
#        attrs = {
#                "user": res['user'],
#                "server": 'twitter.com',
#                "protocol": 'http',
#            }
#        gkey.item_create_sync(gkey.get_default_keyring_sync(),
#                gkey.ITEM_NETWORK_PASSWORD, "twipicuploader", attrs, res['pass'], True)
#    except ImportError:
#        print('gnomekeyring no disponible')


user = "Youwotma"
pas = "<<<PASS<<<TWITPIC>>>"

from sys import argv
if len(argv) >1:
    args = argv[1:] #firs argment is file name, so ignore it
    uploadFiles(args)

