//
// proxy.js
//
// LICENSE: {{{
//     distributable under the terms of an MIT-style license.
//     http://www.opensource.jp/licenses/mit-license.html
// }}}
//
// PLUGIN INFO: {{{
var PLUGIN_INFO = xml`<VimperatorPlugin>
  <name>proxy</name>
  <description>proxy commands.</description>
  <minVersion>2.3pre</minVersion>
  <maxVersion>2.3</maxVersion>
  <license>MIT style license</license>
  <version>0.10.2</version>
  <detail><![CDATA[
    Foobar
  ]]></detail>
</VimperatorPlugin>`;
// }}}
var vimp_server_started = false;


let self = liberator.plugins.proxy = (function(){

    if(!vimp_server_started){
        vimp_server_started = true;
        var async_listener = {
            onStopListening : function(serverSocket, status){},
            onSocketAccepted : function(serverSocket, transport) {

                var stream = transport.openInputStream(0, 0, 0);
                var instream = Components.classes['@mozilla.org/intl/converter-input-stream;1']
                                    .createInstance(Components.interfaces.nsIConverterInputStream);
                instream.init(stream, 'UTF-8', 1024,Components.interfaces.nsIConverterInputStream.DEFAULT_REPLACEMENT_CHARACTER);


                var listener = {
                    requestData : "",
                    onStartRequest: function(request, context){},
                    onStopRequest: function(request, context, status) {
                        instream.close();
                    },
                    onDataAvailable: function(request, context, stream, offset, count) {
                        var str = {}
                        instream.readString(count, str)
                        this.requestData += str.value;
                        var index = this.requestData.indexOf("\n");
                        while(index>=0){
                            var line = this.requestData.substring(0,index);
                            this.requestData = this.requestData.substring(index+1);
                            if(line == "proxyon"){
                                setProxy(true);
                            }else if(line == "proxyoff"){
                                setProxy(false);
                            }
                            index = this.requestData.indexOf("\n");
                        }
                    }
                };

                var pump = Components.classes["@mozilla.org/network/input-stream-pump;1"].createInstance(Components.interfaces.nsIInputStreamPump);
                pump.init(stream, -1, -1, 0, 0, false);
                pump.asyncRead(listener,null);
            }
        };

        serverSocket = Components.classes["@mozilla.org/network/server-socket;1"].createInstance(Components.interfaces.nsIServerSocket);
        serverSocket.init(3142,false,-1);
        serverSocket.asyncListen(async_listener);
        serverStarted = true;
    }

    function setProxy(on){
        Application.prefs.setValue("network.proxy.type",on?1:0);
    }

    commands.addUserCommand(
        ["proxyon"],
        'Turn on proxy on',
        function(a){
            setProxy(true);
        },
        {},
        true
    );
    commands.addUserCommand(
        ["proxyoff"],
        'Turn on proxy off',
        function(a){
            setProxy(false);
        },
        {},
        true
    );

    var PUBLICS = {}

    return PUBLICS;
})();
