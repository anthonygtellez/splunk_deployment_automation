# Create the list of files to iterate through
ls > all_zipfiles_stdout.txt

# iterate through list and run a command 
$ while read line; do unzip "${line}"; done < all_zipfiles_stdout.txt
