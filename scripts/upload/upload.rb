#!/usr/bin/env ruby

require 'json'
require 'fileutils'
require 'dotenv'
Dotenv.load

PARENT_FOLDER_ID=ENV["PARENT_FOLDER_ID"]

subjects = JSON.parse(File.read("./subjects.json"))
departments = JSON.parse(File.read("./departments.json"))
mfqp_json_path = ARGV[0].to_s
mfqp_data = JSON.parse(File.read(mfqp_json_path))

FileUtils.mkdir_p "unidentified"
unidentified_files_path = "./unidentified/"

# subjects not there in the subjects.json file
unidentified_subjects = [ ]

# file name format: mid-spring-2014-CS30002.pdf
filename_regex = /(mid|end)-(spring|autumn)-([0-9]{4})-([A-Z]{2})([0-9]{5}).pdf/
uploading_result_regex = /Id: (.*)/

for i in ARGV
	filename = i
	match_obj = filename_regex.match(filename)
	if not match_obj
		puts "#{filename} does not match the required format"
	else
		semester = match_obj[1] + " " + match_obj[2] + " " + match_obj[3]

		year = match_obj[3].to_i

		subject_code = match_obj[4] + match_obj[5]

		department_code = match_obj[4]

		if departments[department_code] == nil
			puts "ERROR: DEPT: #{department_code}: Dept code not found in departments.json"
			unidentified_subjects.push(filename)
			FileUtils.cp filename, "#{unidentified_files_path}#{File.basename filename}"
			next
		end

		if subjects[subject_code] == nil
			# this file name has a subject code which is not there in the subjects.json
			# file. Probably have to add a node in that file.
			puts "ERROR: SUBJECT: #{filename}: subject code not found in subjects.json"
			unidentified_subjects.push(filename)
			FileUtils.cp filename, "#{unidentified_files_path}#{File.basename filename}"
			next
		end

		department = departments[department_code].downcase
		paper = subjects[subject_code][0].downcase



		# upload the file to drive

		uploading = `drive upload --parent #{PARENT_FOLDER_ID} -f #{filename}`

		puts uploading
		puts uploading.split("\n")[0]

		file_id = uploading_result_regex.match(uploading.split("\n")[0])[1]

		# make the file shareable on drive

		shareable = `drive share -i #{file_id}`

		puts shareable

		# get the preview URL of this file

		preview_url = `drive url -i #{file_id} --preview`

		puts preview_url

		link = preview_url.chomp

		paperObj = { "Department" => department, "Semester" => semester, "Paper" => paper, "Link" => link, "Year" => year.to_s }

		puts paperObj

		mfqp_data.push(paperObj)

		puts "Added to the object"
	end
end

File.delete(mfqp_json_path)
File.open(mfqp_json_path, "w") { |file| file.write(JSON.pretty_generate(mfqp_data)) }

if unidentified_subjects.length > 0
	File.open("failed.txt", "w") { |file| file.write(unidentified_subjects.join("\n")) }
	puts "Check the file failed.txt for a list of all the PDF names with unidentified subject codes"
	puts "Add these subject codes to the subjects.json file, and run this script again."
	puts "Be sure to remove all the PDF files that have already been uploaded."
	puts "Files which could not be processed have been copied to ./unidentified"
end

