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

function getTabArg(tab,arg){
    try{
        switch(arg){
            case "domain": return tab.uri.host;
            case "url": return tab.uri.spec;
        }
    }catch(e){}
    return "";
}

commands.addUserCommand ("switchoropen", "Switch or open",
    function (args) {
        if(args.length != 3){
            liberator.echo("Numero incorrecto de argumentos");
        }else{
            var tabs = Application.activeWindow.tabs;
            var rx = new RegExp(args[1],"i");
            for(var i=0,l=tabs.length; i<l; ++i){
                if(rx.test(getTabArg(tabs[i],args[0]))){
                    tabs[i].focus();
                    return;
                }
            }
            var ios = Components.classes["@mozilla.org/network/io-service;1"].getService(Components.interfaces.nsIIOService);
            var uri = ios.newURI(args[2], null, null);
            Application.activeWindow.open(uri).focus();
        }
    }
);

