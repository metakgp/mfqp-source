# Mail Parser Ruby Script

> Parses entries sent to the metakgp-qp Google Group and outputs a folder of images and PDFs, properly renamed.

### What?

A ruby script which when run in the proper environment will pull down all the images that
were sent to the metakgp-qp Google Group by generous contributors. Some things that this script
will do are:

- Parse the subject of the email to find out the appropriate name of the question paper
that a particular image belongs to (`mid-spring-2016-CS30002`)
- Change the label of all emails that were parsed to `metakgp-qp`
- Change the label of emails that need to be reviewed to one of `metakgp-qp-review-subject` or
`metakgp-qp-review-attachment`.
- Figure out if the attachment was a PDF or a set of Images, and put them into appropriate
folders so that at the end all the PDFs are already properly named in one folder.

### Dependencies

- Run `bundle install` after cloning this script. This script has been tested with Ruby 2.0.
Other versions of Ruby should work just fine, as long as the bundled gems are okay with lower
versions. Check `Gemfile` to know about the gems that this script depends on.
- This scripts uses the Dotenv GEM to get the authentication tokens to connect with Gmail.
The `.env` file must contain an `EMAIL` key and a `OAUTH_TOKEN` key. **This file is never checked
into VCS and can be nuked once the script has been run successfully.**
- This script uses the Gmail GEM, and you can generate the required `OAUTH_TOKEN` by following the
guide given on the `gmail_xoauth` gem [here](https://github.com/nfo/gmail_xoauth#get-your-oauth-20-tokens)
