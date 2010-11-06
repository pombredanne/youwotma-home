#!/usr/bin/python

# Copia las cookies de firefox para usar con wget.
# Lo modifique de algun sitio, pero no me acuerdo

import sqlite3 as db
 
cookiedb = '/home/carl/.mozilla/firefox/3ikna2h4.default/cookies.sqlite'
targetfile = '/home/carl/.cookies.txt'
connection = db.connect(cookiedb)
cursor = connection.cursor()
contents = "host, path, isSecure, expiry, name, value"
 
cursor.execute("SELECT " +contents+ " FROM moz_cookies")
 
file = open(targetfile, 'w')
index = 0
for row in cursor.fetchall():
  file.write("%s\tTRUE\t%s\t%s\t%d\t%s\t%s\n" % (row[0], row[1],
             str(bool(row[2])).upper(), row[3], row[4].encode("ascii","replace"), row[5].encode("ascii","replace")))

  index += 1
 
print "Exportadas: %d" % index
 
file.close()
connection.close()
