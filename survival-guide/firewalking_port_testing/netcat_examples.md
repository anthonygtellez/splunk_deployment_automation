### Using NetCat to test for connectivity
Why NetCat? Um because "telnet is insecure" :unamused: according to security admins, so they don't like to see it installed on the box.

NetCat also lets you create your own packets and specify protocol to get past firewalls.
### Installing NetCat

```
yum install nc -y
apt install nc -y
```
### Basic Syntax Sending
$ nc <hostname> <port>

$ nc 8.8.8.8 80

#### Protocols supported
- TCP *DEFAULT*
- UDP -u
- SSL --ssl

```
$ nc --ssl 8.8.8.8 443
$ nc -u 8.8.8.8 514
```

### Basic Syntax Listening
```
$ nc -l 0.0.0.0 <port>
$ nc -ul 0.0.0.0 514
```
#### Options used:
- l: Listen
- u: udp
- 514: port to listen on
- 0.0.0.0: bind to all interface

### Testing/Faking out Syslog

```
$ echo '<14>*sourcehost* message text' | nc -v -u -w 1 *desthost* 514

$ echo '<14>splunk-src this is a syslog message!' | nc -v -u -w 1 8.8.8.8 514
```
#### Options Used:
- v: verbosity level
- u: UDP
- w: Connect Timeout
