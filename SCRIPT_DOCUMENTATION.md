# Splunk Deployment Automation - Script Documentation

This document provides comprehensive documentation for all shell scripts in the Splunk deployment automation project, along with validation of markdown content accuracy.

## Repository Structure

The repository has been reorganized into two main sections:
- **`splunk/`** - Splunk-specific installation and upgrade scripts
- **`survival-guide/`** - General system administration scripts and documentation

## Table of Contents
1. [Splunk Scripts](#splunk-scripts)
2. [Survival Guide Scripts](#survival-guide-scripts)
3. [Survival Guide Validation](#survival-guide-validation)
4. [Issues Found](#issues-found)

---

## Splunk Scripts

### `splunk/install/splunk-core/`

#### `boot_start-fix.sh`
**Purpose**: Update ulimit settings correctly during Splunk reboot in /etc/init.d/splunk
**Function**: Sets ulimit -Hn to 20240 and ulimit -Sn to 10240 before starting Splunk
**Usage**: Called by init.d script during boot

#### `local.sh`
**Purpose**: Install Splunk Enterprise and complete initial setup steps
**Parameters**: `${1}` = path to splunk install .tgz file
**Usage**: `bash splunkinstall.sh splunk-6.3.2-aaff59bb082c-Linux-x86_64.tgz`
**Privileges**: Must be run as root
**Authors**: Chris Tribie, Anthony Tellez

**Features**:
- Creates splunk user
- Extracts Splunk to /opt/
- Sets up initial configuration
- Changes admin password (interactive)
- Enables boot-start
- Sets proper ownership

#### `remote.sh`
**Purpose**: Remotely install Splunk Enterprise on multiple hosts
**Parameters**: 
- `${1}` = path to splunk install .tgz file
- `${2}` = list of hosts to install on
**Usage**: `bash splunkinstall.sh splunk-6.3.2-aaff59bb082c-Linux-x86_64.tgz hostlist.txt`
**Privileges**: Must be run as root
**Authors**: Anthony Tellez

**Process**:
- Copies install file to each host
- Creates splunk user
- Extracts and configures Splunk
- Enables boot-start
- Handles connection failures gracefully

### `splunk/install/splunk-uf/`

#### `dep-client-local.sh`
**Purpose**: Install Splunk Universal Forwarder with deployment client configuration
**Parameters**: `${1}` = path to splunk install .tgz file
**Usage**: `bash advancedufinstall.sh splunk-6.3.2-aaff59bb082c-Linux-x86_64.tgz`
**Privileges**: Must be run as root
**Authors**: Anthony Tellez

**Features**:
- Creates splunk user
- Installs Universal Forwarder
- Prompts for client name
- Creates deploymentclient.conf with custom client name
- Sets admin password
- Enables boot-start

#### `local.sh`
**Purpose**: Basic Universal Forwarder installation
**Parameters**: `${1}` = path to splunk install .tgz file
**Usage**: `bash splunkinstall.sh splunk-6.3.2-aaff59bb082c-Linux-x86_64.tgz`
**Privileges**: Must be run as root
**Authors**: Chris Tribie, Anthony Tellez

**Features**:
- Creates splunk user
- Installs Universal Forwarder
- Sets admin password
- Enables boot-start

#### `remote.sh`
**Purpose**: Remotely install Universal Forwarder on multiple hosts
**Parameters**: 
- `${1}` = path to splunk install .tgz file
- `${2}` = list of hosts
**Usage**: `bash splunkinstall.sh splunk-6.3.2-aaff59bb082c-Linux-x86_64.tgz hostlist.txt`
**Privileges**: Must be run as root
**Authors**: Anthony Tellez

### `splunk/install/syslog-ng/`

#### `rhel_local_install_syslog-ng.sh`
**Purpose**: Install syslog-ng on RHEL using local RPM files
**Parameters**: None
**Usage**: `bash rhel_local_install_syslog-ng.sh`
**Privileges**: Must be run as root
**Authors**: Anthony Tellez

**Process**:
- Downloads EPEL repository
- Downloads libnet dependency
- Installs dependencies
- Updates yum
- Installs syslog-ng
- Disables rsyslog
- Starts syslog-ng

#### `rhel_yum_install_syslog-ng.sh`
**Purpose**: Install syslog-ng on RHEL using yum with EPEL
**Parameters**: None
**Usage**: `bash rhel_yum_install_syslog-ng.sh`
**Privileges**: Must be run as root
**Authors**: Anthony Tellez

**Process**:
- Downloads EPEL repository
- Installs EPEL
- Updates yum
- Installs syslog-ng
- Disables rsyslog
- Starts syslog-ng

### `splunk/upgrade/splunk-core/`

#### `local.sh`
**Purpose**: Upgrade Splunk Enterprise locally
**Parameters**: `${1}` = path to splunk install file
**Usage**: `bash splunkinstall.sh splunk-6.3.2-aaff59bb082c-Linux-x86_64.tgz`
**Privileges**: Must be run as root
**Authors**: Anthony Tellez

**Process**:
- Stops Splunk
- Extracts new version
- Sets ownership
- Starts Splunk

#### `remote.sh`
**Purpose**: Upgrade Splunk Enterprise on multiple hosts
**Parameters**: 
- `${1}` = path to splunk install file
- `${2}` = list of hosts
**Usage**: `bash upgrade_splunk.sh splunk-6.3.2-aaff59bb082c-Linux-x86_64.tgz hostlist.txt`
**Privileges**: Must be run as root
**Authors**: Chris Tribie, Anthony Tellez

**Process**:
- Copies install file to each host
- Stops Splunk
- Extracts new version
- Starts Splunk
- Handles connection failures

### `splunk/upgrade/splunk-uf/`

#### `local.sh`
**Purpose**: Upgrade Universal Forwarder locally
**Parameters**: `${1}` = path to splunk install file
**Usage**: `bash splunkinstall.sh splunk-6.3.2-aaff59bb082c-Linux-x86_64.tgz`
**Privileges**: Must be run as root
**Authors**: Anthony Tellez

#### `remote.sh`
**Purpose**: Upgrade Universal Forwarder on multiple hosts
**Parameters**: 
- `${1}` = path to splunk install file
- `${2}` = list of hosts
**Usage**: `bash upgrade_splunk.sh splunk-6.3.2-aaff59bb082c-Linux-x86_64.tgz hostlist.txt`
**Privileges**: Must be run as root
**Authors**: Chris Tribie, Anthony Tellez

---

## Survival Guide Scripts

### `survival-guide/aws/`

#### `test_uploads3.sh`
**Purpose**: Upload a file to Amazon S3 to test connectivity during cloud upgrades
**Parameters**: 
- `${1}` = path to file to upload
- `${2}` = s3Key
- `${s3Secret}` = s3Secret (interactive input)
- `${bucket}` = AWS bucket name (hardcoded as "test-bucket-splunk")

**Usage**: `bash test_uploads3.sh some-file.tgz SomeKey`
**Privileges**: Requires curl
**Authors**: Amanda Chen, Anthony Tellez

**Notes**: 
- Uses AWS signature version 2 for authentication
- Content type set to "application/x-compressed-tar"
- Interactive password prompt for s3Secret

### `survival-guide/linux/`

#### `firewalld/splunk-core-service.sh`
**Purpose**: Create custom firewalld service for Splunk Core
**Parameters**: None
**Usage**: `bash configure_firewalld_splunk.sh`
**Privileges**: Must be run as root
**Authors**: Anthony Tellez

**Ports Configured**:
- 8089 (Splunkd REST API)
- 8080 (Splunkd web interface)
- 9997 (Splunk-to-Splunk communication)
- 8000 (Splunk Web)
- 8191 (Splunkd management)
- 8065 (Splunkd management)

#### `firewalld/syslog-ng-service.sh`
**Purpose**: Create custom firewalld service for syslog-ng
**Parameters**: None
**Usage**: `bash configure_firewalld_syslog.sh`
**Privileges**: Must be run as root
**Authors**: Anthony Tellez

**Ports Configured**: UDP ports 514-51460 (extensive range for syslog)

#### `firewalld/uba-service.sh`
**Purpose**: Create custom firewalld service for Splunk UBA
**Parameters**: None
**Usage**: `bash configure_firewalld_uba.sh`
**Privileges**: Must be run as root
**Authors**: Anthony Tellez

**Ports Configured**: Multiple ports for UBA components including:
- 80, 443 (HTTP/HTTPS)
- 6379-6380 (Redis)
- 5432 (PostgreSQL)
- 8089 (Splunkd)
- 6700-6708 (UBA services)
- 2181, 2888, 3888 (Zookeeper)
- And many more for various UBA components

#### `kernel/disable-thp.sh`
**Purpose**: Disable Transparent Huge Pages (THP) using tuned
**Parameters**: None
**Usage**: `bash disable-thp.sh`
**Privileges**: Must be run as root
**Authors**: Anthony Tellez

**Process**:
- Creates custom tuned profile
- Sets transparent_hugepages=never
- Applies custom profile

#### `kernel/increase-ulimit.sh`
**Purpose**: Increase ulimits for Splunk
**Parameters**: None
**Usage**: `bash increase-ulimit.sh`
**Privileges**: Must be run as root
**Authors**: Anthony Tellez

**Configuration**:
- Sets nproc limits
- Sets nofile limits for splunk user
- Updates sysctl.conf
- Modifies limits.conf

#### `kernel/optimize_linux.sh`
**Purpose**: Comprehensive Linux optimization for Splunk
**Parameters**: None
**Usage**: `bash optimize_linux.sh`
**Privileges**: Must be run as root
**Authors**: Mark Macielinski, Anthony Tellez

**Features**:
- Detects OS (CentOS/Ubuntu)
- Increases ulimits
- Disables THP
- Configures PAM (Ubuntu)
- Handles different OS versions

#### `kernel/validate-ulimit.sh`
**Purpose**: Check current ulimits for running Splunk process
**Parameters**: None
**Usage**: `bash validate-ulimit.sh`
**Privileges**: Must be run as root
**Authors**: Anthony Tellez

**Process**:
- Finds splunkd process
- Displays process limits

#### `tcp-stack/optimal-teardown.sh`
**Purpose**: Optimize TCP connection teardown to prevent ulimit issues
**Parameters**: None
**Usage**: `bash optimal-teardown.sh`
**Privileges**: Must be run as root
**Authors**: Anthony Tellez

**Configuration**:
- Sets tcp_keepalive_time to 600 seconds (10 minutes)
- Persists setting in sysctl.conf

### `survival-guide/ssh/`

#### `create_authorized_keys.sh`
**Purpose**: Create SSH authorized_keys for passwordless SSH access
**Parameters**: None
**Usage**: `bash create_authorized_keys.sh`
**Privileges**: Must be run as root
**Authors**: Anthony Tellez

**Process**:
- Creates .ssh directory
- Generates RSA key pair
- Prompts for public key to add
- Sets proper permissions

### `survival-guide/ssl/`

#### `create-serverpem.sh`
**Purpose**: Create server.pem from existing certificates
**Parameters**: None
**Usage**: `bash create-serverpem.sh`
**Privileges**: Requires access to /opt/splunk/etc/auth/
**Authors**: Not specified

**Process**:
- Backs up existing server.pem
- Converts private key to PKCS8 format
- Creates server.pem with certificate chain
- Sets ownership

#### `dod-signed-cert-stripper.sh`
**Purpose**: Extract certificates from DOD certificate files
**Parameters**: `${1}` = certificate file name
**Usage**: `bash dod-signed-cert-stripper.sh hostname001.dod.mil.cer.txt`
**Privileges**: Requires openssl and file ownership
**Authors**: Anthony Tellez

**Output Files**:
- `{name}-server.pem` (server certificate)
- `{name}-cacert.pem` (CA certificate)
- Validates certificates

#### `letsencrypt.sh`
**Purpose**: Replace Splunk certificates with Let's Encrypt certificates
**Parameters**: `${1}` = FQDN of server
**Usage**: `bash letsencrypt.sh hostname.example.com`
**Privileges**: Requires access to certificate files and /opt/splunk/etc/auth/
**Authors**: Anthony Tellez

**Process**:
- Copies Let's Encrypt certificates
- Creates server.pem
- Sets ownership

#### `replace-splunk-certs.sh`
**Purpose**: Replace Splunk certificates with custom certificates
**Parameters**: `${1}` = tar file containing certificates
**Usage**: `bash replace-splunk-certs.sh hostname001.dod.mil.keysandcerts.tar`
**Privileges**: Requires openssl and file ownership
**Authors**: Anthony Tellez

**Process**:
- Extracts certificate files
- Replaces Splunk certificates
- Creates server.pem
- Sets ownership

---

## Survival Guide Validation

### Markdown Files Reviewed

#### `survival-guide/firewalking_port_testing/netcat_examples.md`
**Status**: ✅ ACCURATE
**Content**: NetCat usage examples for network testing
**Validation**: Commands are correct and up-to-date

#### `survival-guide/hacking_tools/README.md`
**Status**: ✅ ACCURATE
**Content**: Splunk administrative access recovery methods
**Validation**: Techniques are valid for Splunk administration

#### `survival-guide/misc_tasks/`
**Status**: ✅ ACCURATE
**Content**: Various Linux command examples
**Validation**: Commands are correct and functional

#### `survival-guide/ssl/open-ssl_cheat_sheet.md`
**Status**: ✅ ACCURATE
**Content**: OpenSSL command reference
**Validation**: All OpenSSL commands are correct and current

#### `survival-guide/ssl/ssl_troubleshooting.md`
**Status**: ✅ ACCURATE
**Content**: SSL troubleshooting guide for Splunk
**Validation**: SSL configuration examples are correct

#### `survival-guide/splunk_configuration/`
**Status**: ✅ ACCURATE
**Content**: Splunk configuration examples and scripts
**Validation**: Configuration examples are valid

#### `survival-guide/sql_queries-dbx/example_sql_queries.md`
**Status**: ✅ ACCURATE
**Content**: SQL query examples for DB Connect
**Validation**: SQL syntax is correct

#### `survival-guide/stream_config/load_pcaps_from_list.md`
**Status**: ✅ ACCURATE
**Content**: PCAP file processing examples
**Validation**: Commands are correct

#### `survival-guide/windows_administration/`
**Status**: ✅ ACCURATE
**Content**: Windows PowerShell examples
**Validation**: PowerShell commands are correct

---

## Issues Found

### Script Issues

1. **`survival-guide/aws/test_uploads3.sh`** - Line 27: Missing `read` command
   ```bash
   # Current (broken):
   d -s -p "set s3Secret: " s3Secret
   
   # Should be:
   read -s -p "set s3Secret: " s3Secret
   ```

2. **`survival-guide/linux/firewalld/uba-service.sh`** - Line 18: Missing quote in EOF
   ```bash
   # Current (broken):
   cat >/etc/firewalld/services/uba.xml <<EOF'<?xml version="1.0" encoding="utf-8"?>
   
   # Should be:
   cat >/etc/firewalld/services/uba.xml <<EOF
   <?xml version="1.0" encoding="utf-8"?>
   ```

3. **`splunk/upgrade/splunk-uf/remote.sh`** - Line 31: Duplicate path in startSplunk command
   ```bash
   # Current (broken):
   startSplunk="sudo su - splunk -c '/opt/opt/splunkforwarder/bin/splunk start --accept-license --answer-yes --no-prompt'"
   
   # Should be:
   startSplunk="sudo su - splunk -c '/opt/splunkforwarder/bin/splunk start --accept-license --answer-yes --no-prompt'"
   ```

### Recommendations

1. **Fix Script Syntax Errors**: The three script syntax errors should be corrected to ensure proper functionality.

2. **Version Updates**: Some scripts reference older Splunk versions (6.3.2) and should be updated to reflect current versions.

3. **Security Review**: The hacking tools section should be reviewed for security implications and proper access controls.

---

## Summary

The Splunk deployment automation project has been reorganized into:

### Splunk Scripts (12 scripts)
- **Install Scripts**: 7 scripts for Splunk and syslog-ng installation
- **Upgrade Scripts**: 4 scripts for Splunk upgrades
- **Boot Scripts**: 1 script for boot configuration

### Survival Guide Scripts (13 scripts)
- **AWS Scripts**: 1 script for S3 connectivity testing
- **Linux Scripts**: 7 scripts for system optimization and firewall configuration
- **SSH Scripts**: 1 script for SSH key management
- **SSL Scripts**: 4 scripts for certificate management

All markdown files in the survival guide are accurate and contain valid commands and examples. The main issues are syntax errors in 3 scripts that should be corrected for proper functionality.