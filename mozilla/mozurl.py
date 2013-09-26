import urllib, json, sys

product = sys.argv[1]
channel = sys.argv[2]

# Assume same version of firefox and thunderbird
version_data = json.loads(urllib.urlopen("http://www.mozilla.org/includes/product-details/json/firefox_versions.json").read())
version_aurora = version_data["FIREFOX_AURORA"]
version_beta = version_data["LATEST_FIREFOX_RELEASED_DEVEL_VERSION"]
version_nightly = "%s.0a1" % (int(version_aurora.split(".")[0]) +1)

print {
    ("firefox","nightly"): "http://ftp.mozilla.org/pub/firefox/nightly/latest-mozilla-central/firefox-%s.en-US.linux-x86_64.tar.bz2" % version_nightly,
    ("firefox","aurora"): "http://ftp.mozilla.org/pub/firefox/nightly/latest-mozilla-aurora/firefox-%s.en-US.linux-x86_64.tar.bz2" % version_aurora,
    ("firefox","beta"): "http://ftp.mozilla.org/pub/mozilla.org/firefox/releases/latest-beta/linux-x86_64/en-US/firefox-%s.tar.bz2" % version_beta,
    ("thunderbird","nightly"): "http://ftp.mozilla.org/pub/thunderbird/nightly/latest-comm-central/thunderbird-%s.en-US.linux-x86_64.tar.bz2" % version_nightly,
    ("thunderbird","aurora"): "http://ftp.mozilla.org/pub/thunderbird/nightly/latest-comm-aurora/thunderbird-%s.en-US.linux-x86_64.tar.bz2" % version_aurora
}[product,channel]

