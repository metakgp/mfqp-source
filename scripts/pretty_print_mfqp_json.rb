require 'json'

if ARGV.length < 2
	puts "You must provide mfqp json path and whether to pretty print it or not as the two arguments"
	exit(1)
end
mfqp_json_path = ARGV[0]
pretty = ARGV[1]
mfqp_data = JSON.parse(File.read(mfqp_json_path))
File.delete(mfqp_json_path)
if pretty == "pretty"
	File.open(mfqp_json_path, "w") { |file| file.write(JSON.pretty_generate(mfqp_data)) }
else
	File.open(mfqp_json_path, "w") { |file| file.write(JSON.generate(mfqp_data)) }
end
