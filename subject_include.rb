#!/usr/bin/env ruby

require 'json'
obj = JSON.parse(File.read("./include/subjects.json"))

for i in ARGV
	if obj[i].is_a?(Array) && obj[i].length == 2 && obj[i][1] == false
		obj[i][1] = true
		puts "Toggled #{i}"
	else
		if obj[i][1]
			puts "#{i} was already true, proceed!"
		else
			puts "#{i} is not a part of this JSON, probably last semester?"
		end
	end
end

File.delete("./include/subjects.json")
File.open("./include/subjects.json", "w") { |file| file.write(JSON.pretty_generate(obj)) }

