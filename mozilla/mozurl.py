import urllib, json, sys

product = sys.argv[1]
channel = sys.argv[2]

# Assume same version of firefox and thunderbird
version_aurora = json.loads(urllib.urlopen("http://www.mozilla.org/includes/product-details/json/firefox_versions.json").read())["FIREFOX_AURORA"]
version_nightly = "%s.0a1" % (int(version_aurora.split(".")[0]) +1)

print {
    ("firefox","nightly"): "ftp://ftp.mozilla.org/pub/firefox/nightly/latest-mozilla-central/firefox-%s.en-US.linux-x86_64.tar.bz2" % version_nightly,
    ("firefox","aurora"): "ftp://ftp.mozilla.org/pub/firefox/nightly/latest-mozilla-aurora/firefox-%s.en-US.linux-x86_64.tar.bz2" % version_aurora,
    ("thunderbird","nightly"): "ftp://ftp.mozilla.org/pub/thunderbird/nightly/latest-comm-central/thunderbird-%s.en-US.linux-x86_64.tar.bz2" % version_nightly,
    ("thunderbird","aurora"): "ftp://ftp.mozilla.org/pub/thunderbird/nightly/latest-comm-aurora/thunderbird-%s.en-US.linux-x86_64.tar.bz2" % version_aurora
}[product,channel]

