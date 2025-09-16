# Splunk Deployment & Automation
Deployment scripts, playbooks and examples for configuring Splunk securely.

## Repository Structure

This repository has been organized into two main sections:

### `splunk/` - Splunk-Specific Scripts
Splunk installation, upgrade, and configuration scripts.

### `survival-guide/` - General System Administration
General Linux, SSL, SSH, and AWS administration scripts and documentation.

## Splunk Scripts

### Installation Scripts
These scripts are used to install Splunk Enterprise and Universal Forwarder on Linux systems.

**Splunk Enterprise:**
```
splunk/install/splunk-core/local.sh          # Local installation
splunk/install/splunk-core/remote.sh         # Remote installation
splunk/install/splunk-core/boot_start-fix.sh # Boot configuration
```

**Universal Forwarder:**
```
splunk/install/splunk-uf/local.sh            # Local installation
splunk/install/splunk-uf/remote.sh           # Remote installation
splunk/install/splunk-uf/dep-client-local.sh # With deployment client config
```

**Syslog-ng:**
```
splunk/install/syslog-ng/rhel_local_install_syslog-ng.sh  # Local RPM install
splunk/install/syslog-ng/rhel_yum_install_syslog-ng.sh    # YUM install
```

### Upgrade Scripts
These scripts are used to upgrade existing Splunk installations.

```
splunk/upgrade/splunk-core/local.sh   # Upgrade Splunk Enterprise locally
splunk/upgrade/splunk-core/remote.sh  # Upgrade Splunk Enterprise remotely
splunk/upgrade/splunk-uf/local.sh     # Upgrade Universal Forwarder locally
splunk/upgrade/splunk-uf/remote.sh    # Upgrade Universal Forwarder remotely
```

## Survival Guide

### Linux System Administration
**Firewall Configuration:**
```
survival-guide/linux/firewalld/splunk-core-service.sh  # Splunk Core ports
survival-guide/linux/firewalld/syslog-ng-service.sh    # Syslog-ng ports
survival-guide/linux/firewalld/uba-service.sh          # UBA ports
```

**Kernel Optimization:**
```
survival-guide/linux/kernel/disable-thp.sh      # Disable Transparent Huge Pages
survival-guide/linux/kernel/increase-ulimit.sh  # Increase system limits
survival-guide/linux/kernel/optimize_linux.sh   # Comprehensive optimization
survival-guide/linux/kernel/validate-ulimit.sh  # Check current limits
```

**TCP Stack Tuning:**
```
survival-guide/linux/tcp-stack/optimal-teardown.sh  # Optimize TCP connections
```

### SSL/TLS Certificate Management
```
survival-guide/ssl/create-serverpem.sh              # Create server.pem
survival-guide/ssl/dod-signed-cert-stripper.sh      # Extract DOD certificates
survival-guide/ssl/letsencrypt.sh                   # Let's Encrypt integration
survival-guide/ssl/replace-splunk-certs.sh          # Replace certificates
survival-guide/ssl/ssl_troubleshooting.md           # SSL troubleshooting guide
survival-guide/ssl/open-ssl_cheat_sheet.md          # OpenSSL command reference
```

### SSH Configuration
```
survival-guide/ssh/create_authorized_keys.sh  # SSH key management
```

### AWS Integration
```
survival-guide/aws/test_uploads3.sh  # S3 connectivity testing
```

### Additional Resources
```
survival-guide/firewalking_port_testing/     # Network testing with NetCat
survival-guide/hacking_tools/                # Splunk administrative tools
survival-guide/misc_tasks/                   # General Linux commands
survival-guide/splunk_configuration/         # Splunk configuration examples
survival-guide/sql_queries-dbx/              # Database query examples
survival-guide/stream_config/                # Stream processing examples
survival-guide/windows_administration/       # Windows PowerShell examples
```

## Usage Notes

- All `.sh` files are executable scripts with detailed comments
- All `.md` files contain documentation and examples
- Scripts have been tested on RHEL7 and Ubuntu 16.04+
- Read script headers for specific usage instructions
- Some scripts require root privileges
- Remote scripts expect hostname/IP lists as input

## Documentation

See `SCRIPT_DOCUMENTATION.md` for comprehensive documentation of all scripts, including parameters, usage examples, and known issues.
