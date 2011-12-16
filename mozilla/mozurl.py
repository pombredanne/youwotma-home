import urllib, json, sys

product = sys.argv[1]

# Assume same version of firefox and thunderbird
version = json.loads(urllib.urlopen("http://www.mozilla.org/includes/product-details/json/firefox_versions.json").read())["FIREFOX_AURORA"]

if product == "firefox":
    print "ftp://ftp.mozilla.org/pub/firefox/nightly/latest-mozilla-aurora/firefox-%s.en-US.linux-x86_64.tar.bz2" % version
elif product == "thunderbird":
    print "ftp://ftp.mozilla.org/pub/thunderbird/nightly/latest-comm-aurora/thunderbird-%s.en-US.linux-x86_64.tar.bz2" % version

