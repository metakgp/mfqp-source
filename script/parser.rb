require 'dotenv'
require 'gmail'

Dotenv.load

gmail = Gmail.connect(:xoauth2,
											ENV["EMAIL"],
											ENV["OAUTH_TOKEN"])

p gmail.inbox.emails(:to => 'metakgp-qp@googlegroups.com').count

# constants
PRODUCTION = false
DATE_AFTER = Date.parse("2016-02-24") # rise of the bot

EMAIL_REGEX = /\[((\w+\s*)+)\]/

	FileUtils.mkdir_p("data/pdf")
FOLDER = File.join(Dir.pwd, 'data')
FOLDER = File.join(Dir.pwd, 'data/pdf')


def parse_subject(subject)
	# parse subject, return nil if error

	parse_sub = subject.scan(EMAIL_REGEX)
	return nil if parse_sub.size < 3

	exam, subject, code = parse_sub.map {|x| x[0].strip.downcase}
	exam = exam.match(/^(mid|end)/).to_s
	year = parse_sub[0][1]

	return {:exam => exam,
		:subject => subject,
		:code => code,
		:year => year}
end

def send_reply(email)
	# https://github.com/gmailgem/gmail#composing-and-sending-emails
end

def create_filename(parsed_subject, original_filename)
	# assume that the default semester is mid-spring-2016
	return "#{parsed_subject.exam}-spring-#{year}-#{parsed_subject.subject.uppercase}.#{original_filename.split(".")[-1]}"
end

def create_unique_filename(parsed_subject, original_filename, file_contents)
	# assume that the default semester is mid-spring-2016
	return "#{parsed_subject.exam}-spring-#{year}-#{parsed_subject.subject.uppercase}-#{Digest::SHA256.hexdigest(file_contents)[0,10]}.#{original_filename.split(".")[-1]}"
end

gmail.inbox.emails(:to => 'metakgp-qp@googlegroups.com', :after => DATE_AFTER) do |email|

	# move emails to new label 
	if PRODUCTION
		email.move_to!('metakgp-qp')
	end

	# parse subject, check sanity, label is mistaken
	subject = email.envelope.subject
	parsed_sub = parse_subject(subject)

	#DEBUG
	p parsed_sub

	if parsed_sub.nil?
		puts "REVIEW SUB: #{subject}"
		if PRODUCTION
			email.label!('metakgp-qp-review-subject')
		end
	else
		if email.message.attachments.length <= 0
			puts "REVIEW ATTACH: #{subject}"
			if PRODUCTION
				email.label!('metakgp-qp-review-attachment')
			end
		else
			puts "PARSED: #{subject} Attached: #{email.message.attachments.length}"
			# check if only one PDF is attached
			if email.message.attachments.length == 1 and email.message.attachments[0].filename.split(".")[-1] == "pdf"
				# save this PDF as the proper file name
				file = email.message.attachments[0]
				new_filename = create_unique_filename(parsed_sub, file.filename)
				File.write(File.join(PDF_FOLDER, new_filename), file.body.decoded)
			else
				# the general case
				# get the filename and append it with the first 10
				# characters of the sha256 hash to ensure uniqueness
				new_filename = create_unique_filename(parsed_sub, f.filename, f.body.decoded.to_s)
				email.message.attachments.each do |f|
					File.write(File.join(FOLDER, new_filename), f.body.decoded)
				end
			end
		end
	end
end
