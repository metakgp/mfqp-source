### Upload and Update - Ruby Script

> Upload and update the paper on MFQP source and MFQP

- You need to have [drive](https://github.com/prasmussen/gdrive/blob/3c7e4127ab7722146ab688dbe0c39e73d8a08b8b/README.md#downloads) in your
`$PATH` env variable. **Note** that the version must be 1.9.0. A later version breaks the regexes that have been assumed inside the script.
- You need to have ruby 2.1.7+ installed on your computer.
- You can run the script as `ruby upload.rb path-to-mfqp-json.json path-to-paper.pdf`
- You can also run the script for multiple pdf files using: `ruby upload.rb path-to-mfqp-json.rb paper-1.pdf paper-2.pdf paper-3.pdf`.
- File name format: `mid-spring-2014-CS30002.pdf`

#### TODO

- [x] Add the link to the readme of all the executables to this readme
- [x] Update the departments.json file
- [x] Update the subjects.json file in this directory to the one that contains
all the subjects (both even and odd semesters)
- [x] Inside the script, update mfqp json.
- [x] Mention the assumption regarding directory structure that has been taken
for updating the mfqp json.
