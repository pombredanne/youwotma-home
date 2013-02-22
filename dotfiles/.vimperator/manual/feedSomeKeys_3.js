/* NEW BSD LICENSE {{{
Copyright (c) 2010-2011, anekos.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

    1. Redistributions of source code must retain the above copyright notice,
       this list of conditions and the following disclaimer.
    2. Redistributions in binary form must reproduce the above copyright notice,
       this list of conditions and the following disclaimer in the documentation
       and/or other materials provided with the distribution.
    3. The names of the authors may not be used to endorse or promote products
       derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
THE POSSIBILITY OF SUCH DAMAGE.


###################################################################################
# http://sourceforge.jp/projects/opensource/wiki/licenses%2Fnew_BSD_license       #
# に参考になる日本語訳がありますが、有効なのは上記英文となります。                #
###################################################################################

*/


(function () {

  const EVENTS = 'keypress keydown keyup'.split(/\s+/);
  const EVENTS_WITH_V = EVENTS.concat(['v' + n for each (n in EVENTS)]);
  const IGNORE_URLS = /<ALL>/;

  const VKeys = {
    '0': KeyEvent.DOM_VK_0,
    '1': KeyEvent.DOM_VK_1,
    '2': KeyEvent.DOM_VK_2,
    '3': KeyEvent.DOM_VK_3,
    '4': KeyEvent.DOM_VK_4,
    '5': KeyEvent.DOM_VK_5,
    '6': KeyEvent.DOM_VK_6,
    '7': KeyEvent.DOM_VK_7,
    '8': KeyEvent.DOM_VK_8,
    '9': KeyEvent.DOM_VK_9,
    ';': KeyEvent.DOM_VK_SEMICOLON,
    '=': KeyEvent.DOM_VK_EQUALS,
    'a': KeyEvent.DOM_VK_A,
    'b': KeyEvent.DOM_VK_B,
    'c': KeyEvent.DOM_VK_C,
    'd': KeyEvent.DOM_VK_D,
    'e': KeyEvent.DOM_VK_E,
    'f': KeyEvent.DOM_VK_F,
    'g': KeyEvent.DOM_VK_G,
    'h': KeyEvent.DOM_VK_H,
    'i': KeyEvent.DOM_VK_I,
    'j': KeyEvent.DOM_VK_J,
    'k': KeyEvent.DOM_VK_K,
    'l': KeyEvent.DOM_VK_L,
    'm': KeyEvent.DOM_VK_M,
    'n': KeyEvent.DOM_VK_N,
    'o': KeyEvent.DOM_VK_O,
    'p': KeyEvent.DOM_VK_P,
    'q': KeyEvent.DOM_VK_Q,
    'r': KeyEvent.DOM_VK_R,
    's': KeyEvent.DOM_VK_S,
    't': KeyEvent.DOM_VK_T,
    'u': KeyEvent.DOM_VK_U,
    'v': KeyEvent.DOM_VK_V,
    'w': KeyEvent.DOM_VK_W,
    'x': KeyEvent.DOM_VK_X,
    'y': KeyEvent.DOM_VK_Y,
    'z': KeyEvent.DOM_VK_Z,
    '*': KeyEvent.DOM_VK_MULTIPLY,
    '+': KeyEvent.DOM_VK_ADD,
    '-': KeyEvent.DOM_VK_SUBTRACT,
    ',': KeyEvent.DOM_VK_COMMA,
    '.': KeyEvent.DOM_VK_PERIOD,
    '/': KeyEvent.DOM_VK_SLASH,
    '?': KeyEvent.DOM_VK_SLASH,
    '`': KeyEvent.DOM_VK_BACK_QUOTE,
    '{': KeyEvent.DOM_VK_OPEN_BRACKET,
    '\\': KeyEvent.DOM_VK_BACK_SLASH,
    '}': KeyEvent.DOM_VK_CLOSE_BRACKET,
    '\'': KeyEvent.DOM_VK_QUOTE
  };

  function id (v)
    v;

  function or (list, func)
    (list.length && let ([head,] = list) (func(head) || or(list.slice(1), func)));

  function getFrames () {
    function bodyCheck (content)
      (content.document && content.document.body && content.document.body.localName.toLowerCase() === 'body');

    function get (content)
      (bodyCheck(content) && result.push(content), Array.slice(content.frames).forEach(get));

    let result = [];
    get(content);
    return result;
  }

  function fromXPath (doc, xpath) {
    let result = util.evaluateXPath(xpath, doc);
    return result.snapshotLength && result.snapshotItem(0);
  }

  function createEvent (eventName, event) {
    let result = content.document.createEvent('KeyEvents');
    result.initKeyEvent(
      eventName,
      true,
      true,
      content,
      event.ctrlKey,
      event.altKey,
      event.shiftKey,
      event.metaKey,
      event.keyCode,
      event.charCode
    );
    return result;
  }

  function virtualize (event) {
    let cc = event.charCode;
    if (/^[A-Z]$/.test(String.fromCharCode(cc)))
      event.shiftKey = true;
    event.keyCode = VKeys[String.fromCharCode(cc).toLowerCase()];
    event.charCode = 0;
    return event;
  }

  function feed (keys, eventNames, target) {
    let _passAllKeys = modes.passAllKeys;
    modes.passAllKeys = true;
    modes.passNextKey = false;

    for (let [, keyEvent] in Iterator(events.fromString(keys))) {
      eventNames.forEach(function (eventName) {
        let ke = util.cloneObject(keyEvent);
        let [, vkey, name] = eventName.match(/^(v)?(.+)$/);
        if (vkey)
          virtualize(ke);
        let event = createEvent(name, ke);
        target.dispatchEvent(event);
      });
    }

    modes.passAllKeys = _passAllKeys;
  }

  function makeTryValidator (func)
    function (value) {
      try {
        liberator.log(value);
        func(value);
        return true;
      } catch (e) {}
      return false;
    };

  let regexpValidator = makeTryValidator(RegExp);

  let xpathValidator =
    makeTryValidator(function (expr) document.evaluate(expr, document, null, null, null))

  function fromModeString (s){
    for (let [, {name, mask, char}] in Iterator(modes._modeMap))
      if (s === name || s === char)
        return mask;
  }

  function fromModeStrings (ss, def) {
    if (def && (!ss || ss.length < 1))
      return [modes.NORMAL];
    return ss.map(fromModeString).filter(function (it) (typeof it === 'number'));
  }

  function modeStringsValidator (ss)
    (!ss || (fromModeStrings(ss).length === ss.length));

  function makeListValidator (list)
    function (values)
      (values && !values.some(function (value) !list.some(function (event) event === value)));

  function findMappings ({all, filter, urls, ignoreUrls, not, result, modes: targetModes}) {
    function match (map) {
      let r = (
        map.feedSomeKeys &&
        (all ||
         (!filter || filter === map.names[0]) &&
         (ignoreUrls || urls === IGNORE_URLS || mappings._matchingUrlsTest(map, urls)))
      );
      if (result && r) {
        if (typeof result.matched === 'number')
          result.matched++;
        else
          result.matched = 1;
      }
      return !!r ^ !!not;
    }

    if (filter)
      filter = mappings._expandLeader(filter);
    if (urls)
      urls = RegExp(urls);

    // FIXME 同じオブジェクトがダブって返るかも(あるいはそれで良い？)
    let result = [];
    for (let [, m] in Iterator(targetModes || [modes.NORMAL]))
      result = result.concat(mappings._user[m].filter(match));

    return result;
  }

  function unmap (condition) {
    condition = Object.create(condition);
    let ms = condition.modes || [modes.NORMAL];
    condition.not = true;
    condition.modes = undefined;
    for (let [, m] in Iterator(ms)) {
      condition.modes = [m];
      mappings._user[m] = findMappings(condition);
    }
  }

  function list (condition) {
  }

  function fmapCompleter (context, args) {
  }

  function urlCompleter ({currentURL}) {
    return function (context, args) {
      let maps = findMappings({all: true});
      let uniq = {};
      let result = [
        (uniq[map.matchingUrls] = 1, [map.matchingUrls.source, map.names])
        for each (map in maps)
        if (map.matchingUrls && !uniq[map.matchingUrls])
      ];
      if (currentURL) {
        result.unshift(['^' + util.escapeRegex(buffer.URL), 'Current URL']);
        result.unshift([util.escapeRegex(content.document.domain), 'Current domain']);
      }
      return result;
    };
  }

  function frameCompleter (context, args) {
    return [
      [i, frame.document.location]
      for each ([i, frame] in Iterator(getFrames()))
    ];
  }

  const ModeStringsCompleter = [
    [name, disp + ' mode' + (char ? ' (alias: ' + char + ')' : '')]
    for ([n, {name, char, disp, extended}] in Iterator(modes._modeMap))
    if (!extended && /^\D+$/.test(n))
  ];


  'fmap fmaps'.split(/\s+/).forEach(function (cmd) {
    let multi = cmd === 'fmaps';

    function action (multi) {
      return function (args) {
        let prefix = args['-prefix'] || '';
        let ms = fromModeStrings(args['-modes'], true);

        function add ([lhs, rhs]) {
          if (!lhs)
            return;

          rhs = rhs || lhs;
          mappings.addUserMap(
            ms,
            [prefix + lhs],
            args['description'] || 'by feedSomeKeys_3.js',
            function () {
              function body (win)
                (win.document.body || win.document);

              let win = document.commandDispatcher.focusedWindow;
              let frames = getFrames();

              let elem = liberator.focus || body(win);

              if (typeof args['-frame'] !== 'undefined') {
                frames = [frames[args['-frame']]];
                elem = body(frames[0]);
              }

              if (args['-xpath']) {
                elem = or(frames, function (f) fromXPath(f.document, args['-xpath'])) || elem;
              }

              feed(rhs, args['-events'] || ['keypress'], elem);
            },
            {
              matchingUrls: args['-urls'],
              feedSomeKeys: {
                rhs: rhs,
              }
            },
            true
          );
        }

        if (multi) {
          let sep = let (s = args['-separator'] || ',') function (v) v.split(s);
          args.literalArg.split(/\s+/).map(String.trim).map(sep).forEach(add);
        } else {
          let [, lhs, rhs] = args.literalArg.match(/^(\S+)\s+(.*)$/) || args.literalArg;
          if (!rhs) {
            list({
              filter: prefix + args.literalArg.trim(),
              urls: args['-urls'],
              ignoreUrls: !args['-urls'],
              modes: ms
            });
          } else {
            add([lhs, rhs]);
          }
        }
      };
    }

    commands.addUserCommand(
      [cmd],
      'Feed map a key sequence',
      action(multi),
      {
        literal: 0,
        options: [
          [['-modes', '-m'], commands.OPTION_LIST, modeStringsValidator, ModeStringsCompleter],
          [['-urls', '-u'], commands.OPTION_STRING, regexpValidator, urlCompleter({currentURL: true})],
          [['-desc', '-description', '-d'], commands.OPTION_STRING],
          [['-frame', '-f'], commands.OPTION_INT, null, frameCompleter],
          [['-xpath', '-x'], commands.OPTION_STRING, xpathValidator],
          [['-prefix', '-p'], commands.OPTION_STRING],
          [
            ['-events', '-e'],
            commands.OPTION_LIST,
            makeListValidator(EVENTS_WITH_V),
            EVENTS_WITH_V.map(function (v) [v, v])
          ]
        ].concat(
          multi ? [[['-separator', '-s'], commands.OPTION_STRING]]
                : []
        ),
        completer: multi ? null : fmapCompleter
      },
      true
    );
  });

  commands.addUserCommand(
    ['fmapc'],
    'Clear fmappings',
    function (args) {
      let ms = fromModeStrings(args['-modes'], true);
      if (args.bang) {
        unmap({ignoreUrls: true, modes: ms});
        liberator.log('All fmappings were removed.');
      } else {
        let result = {};
        unmap({urls: args.literalArg, result: result, modes: ms});
        liberator.echo(result.matched ? 'Some fmappings were removed.' : 'Not found specifed fmappings.');
      }
    },
    {
      literal: 0,
      bang: true,
      completer: function (context) {
        context.title = ['URL Pattern'];
        context.completions = urlCompleter({})(context);
      },
      options: [
        [['-modes', '-m'], commands.OPTION_LIST],
      ]
    },
    true
  );

  commands.addUserCommand(
    ['funmap'],
    'Remove fmappings',
    function (args) {
      let urls = args['-urls'];
      let name = args.literalArg;
      if (!name)
        return liberator.echoerr('E471: Argument required');

      let result = {};
      unmap({
        filter: name,
        urls: urls,
        ignoreUrls: args['-ignoreurls'],
        result: result,
        modes: fromModeStrings(args['-modes'], true)
      });
      liberator.echo(result.matched ? 'Some fmappings were removed.' : 'Not found specifed fmappings.');
    },
    {
      literal: 0,
      options: [
        [['-modes', '-m'], commands.OPTION_LIST]
        [['-urls', '-u'], commands.OPTION_STRING, regexpValidator, urlCompleter({})],
        [['-ignoreurls', '-iu'], commands.OPTION_NOARG]
      ],
      completer: fmapCompleter
    },
    true
  );

  plugins.libly.$U.around(
    mappings,
    'getCandidates',
    function (next, [mode, prefix, patternOrUrl]) {
      let map = mappings.get(mode, prefix, patternOrUrl);
      if (map && map.matchingUrls)
        return [];
      return next();
    }
  );

  __context__.API =
    'VKeys feed getFrames fromXPath virtualize unmap findMappings list'.split(/\s+/).reduce(
      function (result, name)
        (result[name] = eval(name), result),
      {}
    );

})();

// vim:sw=2 ts=2 et si fdm=marker:
