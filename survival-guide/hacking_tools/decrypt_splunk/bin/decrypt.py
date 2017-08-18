import splunk.entity as entity
import splunk.auth, splunk.search

def getCredentials(sessionKey):
    myapp = 'decrypt_splunk'
    try:
        # list all credentials
        entities = entity.getEntities(
            ['admin', 'passwords'], namespace=myapp,
            owner='nobody', sessionKey=sessionKey)
    except Exception, e:
        raise Exception(
            "Could not get %s credentials from splunk."
            "Error: %s" % (myapp, str(e)))
    credentials = []
    # return credentials 
    for i, c in entities.items():
        credentials.append((c['username'], c['clear_password']))
    return credentials
    raise Exception("No credentials have been found")
sessionKey = splunk.auth.getSessionKey('admin','changeme')
credentials = getCredentials(sessionKey)
for username, password in credentials:
    print username
    print password
