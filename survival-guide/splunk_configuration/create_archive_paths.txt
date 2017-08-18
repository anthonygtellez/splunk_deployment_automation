# How to create a list of index names:
$ cat org_all_indexes/local/indexes.conf | grep -i "\[" >> all_indexes_list.txt

# edit the list in vi
$ vi all_indexes_list.txt

# in vi delete the brackets around the index names:
:%s/\[//
:%s/\]//

# Assuming archive space is /archive:
$ cd /archive

# Create a bunch of directories for the indexes using the list:
$ while read line; do mkdir "${line}"; done < all_indexes_list.txt

# rename and remove 3 characters from the left part of a string
$ while read line; do mv "${line}" "${line:3}"; done < broken

# rename and remove 3 characters from the right part of a string
$ while read line; do mv "${line}" "${line::-3}"; done < broken