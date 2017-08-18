# Code written by VladimirShcherbakov, Validated by Anthony Tellez
import urllib2
import urllib
import ssl
import json
from collections import OrderedDict
import base64
import xml.etree.ElementTree as ET
import getopt
import sys

def usage():

	"""
	#################
	How to run this script
	#################

	** All arguments are optional **
	-s: splunkd REST API URL, default: https://localhost:8089
	-u: user name; admin if not specified
	-p: password; changeme if not specified
	-i: Splunk index to set all non-aggregated streams to use
	Examples:
	python stream_update.py
	python stream_update.py -s https://mysplunk:8089 -p mypwd -u splunkuser

	"""
	print usage.__doc__


# Defaults
SPLUNK_SERVER_URL = "https://localhost:8089"
USER = "admin"
PWD = "changeme"
INDEX=""

def update(stream):
	'''put your bulk stream update code here - return True if stream was updated; False otherwise'''

	# check if the stream is aggregated
	is_aggregated = (next((f for f in stream['fields'] if f['aggType'] != 'value'), None) != None)

	retval = False;

	#example: enable 'network_interface' field if it's present
	if (not is_aggregated):
		field = next((f for f in stream['fields'] if f['name'] == 'network_interface'), None)
		if field != None:
			field['enabled'] = True
			retval = True

		if stream['enabled'] != True:
			print "enabling stream " + stream['id']
			stream['enabled'] = True
			retval = True

		if stream['statsOnly'] == True:
			print "turning off estimate mode for stream " + stream['id']
			stream['statsOnly'] = False
			retval = True

		if INDEX != "" and stream.get('index', "") != INDEX:
			print "setting stream's splunk index to " + INDEX
			stream['index'] = INDEX
			retval = True

	return retval # return True if stream was updated by this call

# this prevents certificate validation issues, comment if not needed
ssl._create_default_https_context = ssl._create_unverified_context


"""Helper class to issue a PUT request"""
class MethodRequest(urllib2.Request):
	def __init__(self, *args, **kwargs):
		if 'method' in kwargs:
			self._method = kwargs['method']
			del kwargs['method']
		else:
			self._method = None
		return urllib2.Request.__init__(self, *args, **kwargs)

	def get_method(self, *args, **kwargs):
		if self._method is not None:
			return self._method
		return urllib2.Request.get_method(self, *args, **kwargs)


def readAsJson(data):
	jsonResource = json.loads(data, object_pairs_hook=OrderedDict)
	return jsonResource

def readStreams(url):
	retval = readAsJson(urllib2.urlopen(url + "?output_mode=json").read())
	return retval['entry'][0]['content']


def saveStream(stream, url, sessionKey):
	req_url = url + "?output_mode=json&id=" + stream['id']

	try:
		req = MethodRequest(req_url, method='PUT')
		req.add_header('Authorization', 'Splunk {0}'.format(sessionKey))
		req.add_header('Content-Type', 'application/json')
		req.add_data(json.dumps(stream))
		return urllib2.urlopen(req)
	except urllib2.HTTPError, error:
		print error.read()
		raise error
	except Exception, e:
		raise e


def updateStreams(streams, url):
	# run all streams through the update() method
	for stream in streams:
		#print stream['id']
		if (update(stream)):
			print "Saving stream: " + stream['id']
			saveStream(stream, url, sessionKey)
		else:
			print "Skipping stream: " + stream['id'] + ' - no changes detected'

def login(url):
	req = urllib2.Request(url)
	req.add_data("username=%s&password=%s"  % (USER, PWD))
	responseXml = ET.fromstring(urllib2.urlopen(req).read())
	return responseXml.find('sessionKey').text


if __name__ == '__main__':

	try:
		opts, args = getopt.getopt(sys.argv[1:], 'hs:u:p:i:')
	except getopt.GetoptError:
		print "error"
		usage()
		sys.exit(2)

	for opt, arg in opts:
		if opt in ('-h', '--help'):
			usage()
			sys.exit(2)
		elif opt in ('-s'):
			SPLUNK_SERVER_URL = arg
		elif opt in ('-p'):
			PWD = arg
		elif opt in ('-u'):
			USER = arg
		elif opt in ('-i'):
			INDEX = arg
			if INDEX != "":
				print "Setting Splunk index to " + INDEX

	print "logging to " + SPLUNK_SERVER_URL + " as " + USER

	url_base = SPLUNK_SERVER_URL +  "/services/splunk_app_stream/streams"
	login_url = SPLUNK_SERVER_URL + "/services/auth/login"


	sessionKey = login(login_url)

	streams = readStreams(url_base)

	updateStreams(streams, url_base)
