//
// proxy.js
//
// LICENSE: {{{
//     distributable under the terms of an MIT-style license.
//     http://www.opensource.jp/licenses/mit-license.html
// }}}
//
// PLUGIN INFO: {{{
var PLUGIN_INFO =
<VimperatorPlugin>
  <name>openorswitch</name>
  <description>Abre o cambioa a una pagina.</description>
  <minVersion>2.3pre</minVersion>
  <maxVersion>2.3</maxVersion>
  <license>MIT style license</license>
  <version>0.10.2</version>
  <detail><![CDATA[
    Foobar
  ]]></detail>
</VimperatorPlugin>;
// }}}
commands.addUserCommand ("switchoropen", "Switch or open",
    function (args) {
        if(args.length != 2){
            liberator.echo("Numero incorrecto de argumentos");
        }else{
            var tabs = Application.activeWindow.tabs;
            var rx = new RegExp(args[0],"i");
            for(var i=0,l=tabs.length; i<l; ++i){
                if(rx.test(tabs[i].uri.host)){
                    tabs[i].focus();
                    return;
                }
            }
            var ios = Components.classes["@mozilla.org/network/io-service;1"].getService(Components.interfaces.nsIIOService);
            var uri = ios.newURI(args[1], null, null);
            Application.activeWindow.open(uri).focus();
        }
    }
);


