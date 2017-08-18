# Splunk Deployment & Automation
Deployment scripts, playbooks and examples for for configuring Splunk securely.

### Any content which ends in .sh is an executable script, read the comments on what it does if you can't tell by the name. Anything that ends in .txt or .md are examples of how to perform various tasks in Linux or windows. They are listed here as commands you might need to do during migration or when you are attempting to automate something you don't want to do manually hundreds of times. These have been mostly been tested on RHEL7 and Ubuntu 16.04 over the last 2 years.


### Splunk Core-UF
These script are used to install or upgrade splunk for linux. Local scripts should be used on the host you are trying to install on, remote scripts expect a list of ips or resolvable hostnames or dns names.
```
splunk_automation/install/splunk-core/local.sh
splunk_automation/install/splunk-core/remote.sh
splunk_automation/install/splunk-uf/local.sh
splunk_automation/install/splunk-uf/remote.sh
splunk_automation/upgrade/splunk-core/local.sh
splunk_automation/upgrade/splunk-core/remote.sh
splunk_automation/upgrade/splunk-uf/local.sh
splunk_automation/upgrade/splunk-uf/remote.sh
```

### OS Firewall Tuning
These scripts are for rhel 7. They open the correct ports needed for splunk core, uba & syslog-ng. The firewalld services are XML based, so you can tweak the scripts as needed.
```
splunk_automation/rhlinux/firewalld/splunk-core-service.sh
splunk_automation/rhlinux/firewalld/syslog-ng-service.sh
splunk_automation/rhlinux/firewalld/uba-service.sh
```

### OS Kernel Tuning
These scripts are used to disable-thp on linux and reconfigure the ulimits. Validate ulimits checks what ulimits the splunkd pid currently has. You may need to restart splunkd for these settings to take effect.
```
splunk_automation/linux/kernel/disable-thp.sh
splunk_automation/linux/kernel/increase-ulimit.sh
splunk_automation/linux/kernel/validate-ulimit.sh
```

## install_syslog-ng
Test scripts for installing syslog-ng on RHEL. The yum install works only if the EPEL is configured upstream.
```
./install_syslog-ng/rhel_local_install_syslog-ng.sh
./install_syslog-ng/rhel_yum_install_syslog-ng.sh
```


## misc_tasks
```
./misc_tasks/loop_through_list_and_cmd.txt
./misc_tasks/misc_tasks.txt
./misc_tasks/progress_bar.txt
```

## splunk_configuration
```
./splunk_configuration/create_archive_paths.txt
./splunk_configuration/edit_multiple_files_in_local.txt
./splunk_configuration/install_db_connect.sh
./splunk_configuration/itsi_installer.sh
./splunk_configuration/multitenant_appbuilder.sh
./splunk_configuration/multitenant_tabuilder.sh
```

## ssh_config
```
./ssh_config/create_authorized_keys.sh
```

## stream_config
```
./stream_config/load_pcaps_from_list.txt
./stream_config/stream_update.py
```

## syslog_ng_configs
```
./syslog_ng_configs/syslog-ng_ip.conf
./syslog_ng_configs/syslog-ng_port.conf
```

## windows_administration
```
./windows_administration/create_server_list.txt
./windows_administration/remote_start_stop_splunk.txt
```
