#!/usr/bin/env ruby

require 'json'

subjects = JSON.parse(File.read("./subjects.json"))
departments = JSON.parse(File.read("./departments.json"))

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

		department = departments[department_code].downcase
		paper = subjects[subject_code][0].downcase

		# upload the file to drive

		uploading = `drive upload -f #{filename}`

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

		paperObj = { "Department" => department, "Semester" => semester, "Paper" => paper, "Link" => link, "Year" => year }

		puts paperObj
	end
end
