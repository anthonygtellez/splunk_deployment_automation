# Hacking Tools for Splunk

### What
These are known manipulations to Splunk, they require local access to the system in order to perform. They are not considered CVEs or anything of that nature since they require cli access to the host system.

- Reset Admin Account
- Decrypt Pass4Symmkey

### Why
This project is intended to give you access to the Admin account or the Pass4Symmkey in the event these credentials are forgotten. 

### How

### Resetting Admin Account:
By Default, Splunk credentials are stored in $SPLUNK_HOME/etc/passwd:

```
$ cat passwd
:admin:$6$qsBZ3jtfnKCkB3Fq$H14A20UT6617WzFBMPm4YSEnX6jnV7dfgqRf/FX6t1.aqVdDz8VrSdzdoOrHcJ/Ae1FO5XHfnzwpcKl2AZWH90::Administrator:admin:changeme@example.com::
```

The password can only be viewed by using splunk.secret to decrypt. In order to get around needing to decrypt the password, you can simply rename the passwd file, which will reset the password for the Admin account to "changeme". 

Steps:
* Shut down Splunk Instance
* Delete or Rename the passwd file
* Start Splunk back up
* Access with default credentials admin:changeme

#### Advanced
- What about when you are on a production system and there are other users in the passwd file?

```
$ cat passwd
:admin:$6$qsBZ3jtfnKCkB3Fq$H14A20UT6617WzFBMPm4YSEnX6jnV7dfgqRf/FX6t1.aqVdDz8VrSdzdoOrHcJ/Ae1FO5XHfnzwpcKl2AZWH90::Administrator:admin:changeme@example.com::
:atellez:$6$LwY3gVFSV.OMJHjP$SpYEiFGVlqMaPQePE/HqAlnSZtNW3WMdrZkIsbk6/LTeL6JhnEBHnZ0l07SQ/vlQn1QCdJGrq4w.cMqOUxtHh.::Anthony Tellez:admin:atellez@splunk.com::
```

You can clone the passwd file, and delete file. You need to be careful about any users who are using the local login because their knowledge objects will be temporarily orphaned and they will be unable to login. After a restart the admin user should be back to the default password of changeme. Once you've completed your tasks you can put the original password file back into place. Alternatively, you can merge the user accounts into the bottom of the new passwd file.

Steps:
* Shut down Splunk Instance
* clone passwd file (Crate a backup)
* Delete passwd file
* Start Splunk Instance
* Access with default credentials admin:changeme
* Make changes needed with the admin user
* Optional Restore or Merge: shutdown splunk, restore original file, start splunk back up

### Decrypt credentials:
- Sometimes it isn't possible to just redo all the Pass4Symmkey configurations across many hosts for clustering. This is where decryption can come in handy. 
- This technique takes information from a blog by hurricane labs: [https://www.hurricanelabs.com/blog/decrypt-passwords-encrypted-by-splunk/] and packages it as an app located in this repo for easier use without the need to redevelop each part.

#### Requirements:
* Splunk.Secret from the host you're trying to decrypt Pass4Symmkey
* Clean environment to manipulate
* Pass4Symmkey you need to decrypt

#### Gotchas:
* Fresh install uses splunk.secret to hash various configurations which will break until you reset them
* Namely SSL configurations for REST & SplunkWeb

Files to reset:
```
$SPLUNK_HOME/etc/system/local/server.conf
$SPLUNK_HOME/etc/passwd

[general]
serverName = splunk-hacking
pass4SymmKey = $1$cmeZzDfH0mh8

[sslConfig]
sslPassword = $1$JSvNkHKBmTp8 
```
sslPassword needs to be reset to password for the REST SSL to work properly.
Admin account needs to be reset (delete passwd file once new splunk.secret is in place) otherwise splunk won't let you login.

Steps:
* Copy decrypt_splunk to the apps directory
* Update app.conf with the Pass4Symmkey you are trying to decrypt
* Replace the splunk.secret with the matching one from your production host
* Remove the passwd file, update ssl configurations
* Restart splunk so the splunk.secret is used to rehash everything
* Use the python script in the following syntax to decrypt replacing $SPLUNK_HOME with the appropriate directory:

```
$SPLUNK_HOME/bin/splunk cmd python $SPLUNK_HOME/etc/apps/decrypt_splunk/bin/decrypt.py
```
