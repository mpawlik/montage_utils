#!/usr/bin/env python2

import SocketServer
import SimpleHTTPServer
import urllib

PORT = 80

class Proxy(SimpleHTTPServer.SimpleHTTPRequestHandler):
    def do_GET(self):
        print self.path
        self.copyfile(urllib.urlopen('https://irsa.ipac.caltech.edu' + self.path), self.wfile)

httpd = SocketServer.ForkingTCPServer(('', PORT), Proxy)
print "serving at port", PORT
httpd.serve_forever()
