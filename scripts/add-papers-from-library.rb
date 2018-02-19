# Ruby Script to add papers that have been scraped from the library site using
# something like wget -mr, mirroring the complete site with directory structure
# as well
#
# CLI Parameters: MFQP data.json's path must be the first parameter. The year
# directory inside which the script is being run should be the second parameter
# 
# Run this script from inside 10.17.32.9/peqp/*
# This script will walk through all the PDF files found at one directory level
# below the present directory, and add these to the MFQP JSON.
# This will pretty print the JSON, if you want to remove pretty print, run the
# script pretty_print_mfqp_json with argument "unpretty".
#
# Siddharth Kannan <kannan.siddharth12@gmail.com>

require 'json'
require 'uri'

mfqp_json_path = ARGV[0]
mfqp_json_text = File.read(mfqp_json_path)
data = JSON.parse(mfqp_json_text)

list_files = Dir["./**/*.pdf"]

def construct_obj(department, semester, paper, link, year)
	return {
		"Department" => department.to_s,
		"Semester" => semester.to_s,
		"Link" => link.to_s,
		"Paper" => paper.to_s,
		"Year" => year.to_s
	}
end

list_files.each do |file_name|
	
	year = ARGV[1].to_s
	root_dir, semester, department, paper = file_name.split('/')
	file_link = file_name.sub root_dir, "http://10.17.32.9/peqp/#{year}"
	file_link = URI.encode file_link
	paper.sub! ".pdf", ""

    if !mfqp_json_text.index(file_link)
        data.push(construct_obj(department, semester, paper, file_link, year))
        puts "Pushed object for #{paper} in #{department} and #{semester}"
    else
        puts "#{file_name} already exists"
    end
	
end
File.delete(mfqp_json_path)
File.open(mfqp_json_path, "w") { |file| file.write(JSON.pretty_generate(data)) }
