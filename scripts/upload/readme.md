## Upload and Update - Ruby Script

> Upload and update the paper on MFQP source and MFQP

### Steps to run this script

1. You NEED to have [drive](https://github.com/prasmussen/gdrive/blob/3c7e4127ab7722146ab688dbe0c39e73d8a08b8b/README.md#downloads) in your
`$PATH` env variable. **Note** that the version must be 1.9.0. A later version breaks the regexes that have been assumed inside the script.
2. You MUST have a `.env` file with the environment variable `PARENT_FOLDER_ID`
3. Now, run the command `drive upload -f test_file` (`test_file` can be any
   file, this is only to generate the O-Auth token that we need to start
   uploading files)
    1. this will point you to a link
    2. open an incognito window, paste the given URL there
    3. Login to the Metakgp Gmail ID
    4. grant access to the application
    5. copy the token displayed on the browser window back to the terminal
  Now, the Drive executable has a token, so you can upload files!
4. You need to have ruby 2.1.7+ installed on your computer.
5. You can run the script as `ruby upload.rb path-to-mfqp-json.json path-to-paper.pdf`
6. You can also run the script for multiple pdf files using: `ruby upload.rb path-to-mfqp-json.rb paper-1.pdf paper-2.pdf paper-3.pdf`.
7. File name format: `mid-spring-2014-CS30002.pdf`
8. Unprocessed files will be inside `./unidentified`. `.` here is the directory
   from which you run the command provided in step 5

#### TODO

- [x] Add the link to the readme of all the executables to this readme
- [x] Update the departments.json file
- [x] Update the subjects.json file in this directory to the one that contains
all the subjects (both even and odd semesters)
- [x] Inside the script, update mfqp json.
- [x] Mention the assumption regarding directory structure that has been taken
for updating the mfqp json.
