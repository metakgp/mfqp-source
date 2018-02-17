# Scripts

Script | Purpose | Author
:---: | :---: | :---:
images-to-pdfs | Given a directory of question paper images, this script will convert them to PDFs; provided they are named properly | Athitya Kumar
parser | Parse emails sent to the metakgp-qp google group and output a folder of images and appropriately named PDFs | Siddharth
upload | Given a set of appropriately named PDF files, upload them to Google Drive and add a record for each of them in the MFQP JSON | Siddharth, Naresh
add-papers-from-library.rb | Given the output of `wget -mr peqp_site`, add the appropriate entries to the MFQP JSON | Siddharth
fix-json-objects.rb | Check JSON objects for the `Link` attribute. If not present, infer them using the `Paper` attribute | Siddharth
sub_json_from_ct.py | ??? | Harsh
fix-names.rb | UTF encode a particular attribute in each record of the MFQP JSON | Siddharth
pretty_print_mfqp_json.rb | Pretty print the MFQP JSON | Siddharth
