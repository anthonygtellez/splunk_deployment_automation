# convert all values in a list of a file to lowercase:
tr '[:upper:]' '[:lower:]' < inputfile.txt >> outputfile.txt

#convert all values in a list of a file to uppercase: 
tr '[:lower:]' '[:upper:]' < inputfile.txt >> outputfile.txt

# create directory & subdirectories
mkdir -p /root/child/grandchild/