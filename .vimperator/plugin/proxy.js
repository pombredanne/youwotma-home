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
  <name>proxy</name>
  <description>proxy commands.</description>
  <minVersion>2.3pre</minVersion>
  <maxVersion>2.3</maxVersion>
  <license>MIT style license</license>
  <version>0.10.2</version>
  <detail><![CDATA[
    Foobar
  ]]></detail>
</VimperatorPlugin>;
// }}}

let self = liberator.plugins.proxy = (function(){

    commands.addUserCommand(
        ["proxyon"],
        'Turn on proxy on',
        function(a){
            Application.prefs.setValue("network.proxy.type",1);
        },
        {},
        true
    );
    commands.addUserCommand(
        ["proxyoff"],
        'Turn on proxy off',
        function(a){
            Application.prefs.setValue("network.proxy.type",0);
        },
        {},
        true
    );

    var PUBLICS = {}

    return PUBLICS;
})();
