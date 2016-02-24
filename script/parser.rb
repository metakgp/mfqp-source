require 'gmail'

gmail = Gmail.connect(:xoauth2,
                      'EMAIL',
                      'TOKEN')

p gmail.inbox.emails(:to => 'metakgp-qp@googlegroups.com').count

# constants
EMAIL_REGEX = /\[((\w+\s*)+)\]/
DATE_AFTER = Date.parse("2016-02-24") # rise of the bot
FOLDER = File.join(Dir.pwd, 'data')


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


gmail.inbox.emails(:to => 'metakgp-qp@googlegroups.com',
                   :after => DATE_AFTER) do |email|

  # move emails to new label 
  email.move_to!('metakgp-qp')

  # parse subject, check sanity, label is mistaken
  subject = email.envelope.subject
  parsed_sub = parse_subject(subject)

  #DEBUG
  p parsed_sub

  if parsed_sub.nil?
    email.label!('metakgp-qp-review')
  else
    unless subject.scan('Re: ')
      email.message.attachments.each do |f|
          File.write(File.join(FOLDER, f.filename), f.body.decoded)
        end
    end
  end
end
