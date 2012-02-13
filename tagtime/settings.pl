# Settings for TagTime.
# This file must be in your home directory, called .tagtimerc
# NB: restart the daemon (tagtimed.pl) if you change this file.

$usr = "carl";                            # your username -- CHANGEME
$path = "/home/carl/dev/TagTime/";        # path to tagtime -- CHANGEME
        if($path !~ /\/$/) { $path.="/"; }
$logf = "$path$usr.log";  # log file for pings

# If you're using windows, you'll need cygwin and to set this flag to 1:
$cygwin = 0;                              # CHANGEME to 1 if you're using windows/cygwin.

$ED = "/usr/bin/vi +";                    # CHANGEME if you don't like vi (eg: /usr/bin/pico)
$XT = "/usr/bin/xterm";                   # path to xterm -- possibly CHANGEME

# System settings follow...

# CHANGEME: add entries for each beeminder graph you want to auto-update:
%beeminder = (
  #"alice/work" => ["job"],  # all "job" pings get added to bmndr.com/alice/work
  #"bob/play" => ["fun","whee"], # pings w/ "fun" and/or "whee" sent to bob/play

  # ADVANCED USAGE: regular expressions
  # pings tagged like "eat1", "eat2", "eat3" get added to carol/food:
  #"carol/food" => qr/\beat\d+\b/,

  # ADVANCED USAGE: plug-in functions
  # pings tagged anything except "afk" get added to "dan/nafk":
  #"dan/nafk" => sub { return shift() !~ /\bafk\b/; }
  # pings tagged "workout" get added to dave/tueworkouts, but only on tuesdays:
  #"dave/tueworkouts" => sub { my @now = localtime();
  # return shift() =~/\bworkout\b/ && $now[6] == 2;
  #}
);

# Pings from more than this many seconds ago get autologged with tags
# "afk" and "RETRO".  (Pings can be overdue either because the
# computer was off or tagtime was waiting for you to answer a 
# previous ping.  If the computer was off, the tag "off" is also
# added.)
$retrothresh = 60;

$gap = 45*60; # Average number of seconds between pings (eg, 60*60 = 1 hour).

$seed = 666; # For pings not in sync with others, change this (NB: > 0).

$linelen = 79; # Try to keep log lines at most this long.

$catchup = 0;  # Whether it beeps for old pings, ie, should it beep a bunch
               # of times in a row when the computer wakes from sleep.

$enforcenums = 0;  # Whether it forces you to include a number in your
                   # ping response (include tag non or nonXX where XX is day 
                   # of month to override). This is for task editor integration.

# System command that will play a sound for pings.
# If you've compiled playsound in sound subdir you can change this to, eg:
# $playsound = "${path}sound/playsound ${path}sound/blip-twang.wav";
# $playsound = "echo -e '\a'"; # this is the default if $playsound not defined.
# $playsound = "";  # makes tagtime stay quiet.


1; # When requiring a library in perl it has to return 1.
