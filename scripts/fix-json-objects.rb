require 'uri'
require 'json'

json_path = ARGV[0]
data = JSON.parse(File.read(json_path))

data.each do |paper|
	if paper["Paper"].scan(/http:\/\//).count > 0
		if not paper["Link"]
			paper["Link"] = paper["Paper"]
			if paper["Link"].include? ".pdf"
				paper["Paper"] = paper["Link"].split("/")[-1].split(".")[0]
			end
			puts "Found a problem, fixed to #{paper["Paper"]} with link #{paper["Link"]}"
		end
	end
end

File.write json_path, JSON.pretty_generate(data)
