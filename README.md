PamFaxr
=======

Ruby library for sending faxes via the [PamFax](http://www.pamfax.biz/en/partners/tropo/) Simple API.

Overview
--------

You may send faxes using the PamFax API. See the [PamFax Developer](http://www.pamfax.biz/en/partners/tropo/) page for more details and how to get your developer key.

Requirements
------------

Requires these gems, also in the Gemfile:

	* json
	* mime-types

Example
-------

    # Create a new PamFaxr object
	pamfaxr = PamFaxr.new :key      => 'your_api_key', 
	                      :secret   => 'your_api_secret', 
	                      :username => 'your_username', 
	                      :password => 'your_password'
	# Create a new FaxJob
	pamfaxr.create_fax_job
    # Add the cover sheet
	covers = pamfaxr.list_available_covers
	pamfaxr.set_cover(covers['Covers']['content'][1]['id'], 'Foobar is here!')
	# Add files
	pamfaxr.add_remote_file('https://s3.amazonaws.com/pamfax-test/Tropo.pdf')
	pamfaxr.add_file('examples/Tropo.pdf')
	# Add a recipient
	pamfaxr.add_recipient('+14155551212')
	# Loop until the fax is ready to send
	loop do
	  fax_state = pamfaxr.get_state
	  break if fax_state['FaxContainer']['state'] == 'ready_to_send'
	  sleep 5
	end
	# Send the fax
	pamfaxr.send_fax