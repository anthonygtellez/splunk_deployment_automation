# Create the list of pcap files to iterate through
ls */*.pcap > all_pcap_files.txt

# append absolute path to beginning of each line in vi
:%s/^/\/splunk\//c

# iterate through list and index using stream
$ while read line; do ./streamfwd "${line}"; done < all_pcap_files.txt
