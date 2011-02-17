# Send faxes from the commandline
# USAGE: hello_pamfax.rb username password number [message]
require 'rubygems'
require 'lib/pamfaxr'

#Check commandline arguments
if 3 > ARGV.length || 4 < ARGV.length
	abort('USAGE: hello_pamfax.rb username password number [message]')
end

# Pass user name and password
pamfaxr = PamFaxr.new :username => ARGV[0], 
                      :password => ARGV[1]

# Create a faxjob
faxjob = pamfaxr.create_fax_job

# Add cover and text
covers = pamfaxr.list_available_covers
pamfaxr.set_cover(covers['Covers']['content'][1]['id'], (4 == ARGV.length ? ARGV[3] : 'Hello, world'))
pamfaxr.add_recipient(ARGV[2])

# Loop until ready to send
loop do
  fax_state = pamfaxr.get_state
  converting = true
  break if fax_state['FaxContainer']['state'] == 'ready_to_send'
  sleep 15
end

# Send
pamfaxr.send_fax

