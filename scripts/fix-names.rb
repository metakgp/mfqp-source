require 'uri'
require 'json'

record_key = "Department"

json_path = ARGV[0]
data = JSON.parse(File.read(json_path))

data.each do |paper|
	old = paper[record_key]
	paper[record_key] = URI.decode(paper[record_key]).force_encoding("iso-8859-1").encode("utf-8")

	if old != paper[record_key]
		puts "changed #{old} to #{paper[record_key]}"
	end
end

# File.delete JSON_path
File.write json_path, JSON.pretty_generate(data)
