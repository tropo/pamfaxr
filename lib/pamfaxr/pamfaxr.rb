class PamFaxr
  class FaxJob

    ##
    # Instantiates the FaxJob class
    #
    # @param [Hash] params the options for instantiating a FaxJob class
    # @option params [String] :api_credentials the credentials for accessing the PamFax API
    # @option params [Object] :http an SSL enabled net/http object
    #
    # @return [Object] the instantiated FaxJob class
    def initialize(options={})
      @base_resource   = '/FaxJob'
      @api_credentials = options[:api_credentials]
      @http            = options[:http]
    end
    
    ##
    # Creates a new fax job
    #
    # @return [Hash] the result of the fax job creation request
    #
    # @example
    #   pamfaxr.create_fax_job
    #  
    #   returns:
    #
    #   {
    #           "result" => {
    #            "code" => "success",
    #           "count" => 1,
    #         "message" => ""
    #     },
    #     "FaxContainer" => {
    #                      "price" => 0,
    #                  "send_mail" => 0,
    #                       "uuid" => "ebKVV4XGwx99Wu",
    #         "error_notification" => 0,
    #         "group_notification" => 0,
    #                   "send_sms" => 0,
    #              "currency_rate" => 1,
    #          "cover_page_length" => nil,
    #                  "send_chat" => 0,
    #                      "pages" => nil,
    #                   "cover_id" => 0,
    #                   "currency" => true,
    #           "affiliatepartner" => nil,
    #                    "updated" => nil,
    #                 "cover_text" => nil,
    #         "processing_started" => nil,
    #                    "created" => "2011-01-17 19:27:57",
    #                      "state" => "editing"
    #     }
    #   }
    def create_fax_job
      resource = @base_resource + "/Create" + @api_credentials + "&user_ip=#{Socket.gethostname}&user_agent=pamfax.rb&origin=script"
      get(resource)
    end
    
    ##
    # Adds a recipient to a fax job
    #
    # @param [String] the phone number to add to the fax job
    #
    # @return [Hash] the result of the add recipient request
    #
    # @example adding a recipient
    #   pamfaxr.add_recipient('14155551212')
    #
    #   returns:
    #
    #   {
    #           "result" => {
    #            "code" => "success",
    #           "count" => 1,
    #         "message" => ""
    #     },
    #     "FaxRecipient" => {
    #         "price_per_page" => 0.09,
    #                   "name" => "",
    #                 "number" => "+14155551212",
    #           "price_source" => "PNR",
    #                "country" => "US",
    #              "area_code" => "415",
    #                   "zone" => "1",
    #            "number_type" => "FIXED",
    #            "description" => "California (CA)"
    #     }
    #   }
    def add_recipient(number)
      resource = @base_resource + "/AddRecipient" + @api_credentials + "&number=#{number}"
      get(resource)
    end
    
    ##
    # Adds a local file to the fax job
    #
    # @param [string, Required] filename to add to the fax including full path
    #
    # @return [Hash] the result of the request to add a file
    #
    # @example adding a local file
    #   pamfaxr.add_file('/path_to_my_file/filename.pdf')
    #
    #   returns:
    #
    #   {
    #               "result" => {
    #            "code" => "success",
    #           "count" => 1,
    #         "message" => ""
    #     },
    #     "FaxContainerFile" => {
    #               "name" => "/path_to_my_file/filename.pdf",
    #         "file_order" => 1,
    #                "ext" => "pdf",
    #          "file_uuid" => "JNMi19AeQ6QkoC",
    #               "mime" => "application/pdf",
    #              "state" => ""
    #     }
    #   }
    def add_file(filename)
      data, headers = Multipart::Post.prepare_query({ 'filename' => filename, 'file' => File.open(File.join(filename)) })
      resource = @base_resource + "/AddFile" + @api_credentials
      post(resource, data, headers)
    end
    
    ##
    # Adds a remote file to the fax job
    #
    # @param [required, String] url of the file to send with the fax, http basic auth is optional
    #
    # @return [Hash] the result of the request to add a file
    #
    # @example adding a remote file
    #   pamfaxr.add_remote_file('https://s3.amazonaws.com/pamfax-test/Tropo.pdf')
    #
    #   returns:
    #
    #   {
    #               "result" => {
    #            "code" => "success",
    #           "count" => 1,
    #         "message" => ""
    #     },
    #     "FaxContainerFile" => {
    #               "name" => "Tropo.pdf",
    #         "file_order" => 0,
    #                "ext" => "pdf",
    #          "file_uuid" => "CwPx31xjl9k7Cp",
    #               "mime" => "application/pdf",
    #              "state" => ""
    #     }
    #   }
    def add_remote_file(url)
      resource = @base_resource + "/AddRemoteFile" + @api_credentials + "&url=#{url}"
      get(resource)
    end
    
    ##
    # Cancel an outstanding fax
    # 
    # @param [required, String] uuid of the fax to cancel
    #
    # @return [Hash] the result of the request to cancel an outstanding fax
    #
    # @example cancel a fax
    #   pamfaxr.cancel('ebKVV4XGwx99Wu')
    #
    #   returns:
    #
    #   {
    #     "result" => {
    #            "code" => "success",
    #           "count" => 0,
    #         "message" => ""
    #     }
    #   }
    def cancel(uuid)
      resource = @base_resource + "/Cancel" + @api_credentials + "&uuid=#{uuid}"
      get(resource)
    end

    ##
    # Clone a fax job
    # 
    # @param [required, String] uuid of the fax to clone
    #
    # @return [Hash] the result of the request to clone an outstanding fax
    #
    # @example cloning a sent fax
    #   pamfaxr.clone_fax('ebKVV4XGwx99Wu')
    #   
    #   returns:
    #
    #   {
    #     "result" => {
    #            "code" => "fax_not_found",
    #           "count" => 0,
    #         "message" => "Fax not found"
    #     }
    #   }
    def clone_fax(uuid)
      resource = @base_resource + "/CloneFax" + @api_credentials + "&user_ip=#{Socket.gethostname}&user_agent=pamfax.rb&uuid=#{uuid}"
      get(resource)
    end
    
    ##
    # Returns the available cover templates
    # 
    # @return [Array] an array of hashes of the available covers
    #
    # @example list available fax covers
    #   pamfaxr.list_available_covers
    #
    #   returns:
    #
    #   {
    #     "result" => {
    #            "code" => "success",
    #           "count" => 1,
    #         "message" => ""
    #     },
    #     "Covers" => {
    #            "type" => "list",
    #         "content" => [
    #             [0] {
    #                 "template_id" => "eae27d77ca20db309e056e3d2dcd7d69",
    #                       "title" => "Basic",
    #                     "creator" => 0,
    #                          "id" => 1,
    #                    "thumb_id" => "091d584fced301b442654dd8c23b3fc9",
    #                 "description" => nil,
    #                  "preview_id" => "7eabe3a1649ffa2b3ff8c02ebfd5659f"
    #             },
    #             [1] {
    #                 "template_id" => "ca46c1b9512a7a8315fa3c5a946e8265",
    #                       "title" => "Flowers",
    #                     "creator" => 0,
    #                          "id" => 3,
    #                    "thumb_id" => "45fbc6d3e05ebd93369ce542e8f2322d",
    #                 "description" => nil,
    #                  "preview_id" => "979d472a84804b9f647bc185a877a8b5"
    #             },
    #             [2] {
    #                 "template_id" => "e96ed478dab8595a7dbda4cbcbee168f",
    #                       "title" => "Message",
    #                     "creator" => 0,
    #                          "id" => 4,
    #                    "thumb_id" => "ec8ce6abb3e952a85b8551ba726a1227",
    #                 "description" => nil,
    #                  "preview_id" => "63dc7ed1010d3c3b8269faf0ba7491d4"
    #             },
    #             [3] {
    #                 "template_id" => "f340f1b1f65b6df5b5e3f94d95b11daf",
    #                       "title" => "Simple",
    #                     "creator" => 0,
    #                          "id" => 5,
    #                    "thumb_id" => "335f5352088d7d9bf74191e006d8e24c",
    #                 "description" => nil,
    #                  "preview_id" => "cb70ab375662576bd1ac5aaf16b3fca4"
    #             }
    #         ]
    #     }
    #   }
    def list_available_covers
      resource = @base_resource + "/ListAvailableCovers" + @api_credentials
      get(resource)
    end

    ##
    # Returns the files associated to the current faxjob
    # 
    # @return [Array] an array of hashes of the associated files
    #
    # @example listing fax files associated to a job
    #   pamfaxr.list_fax_files
    #
    #   returns:
    #
    #   {
    #     "result" => {
    #            "code" => "success",
    #           "count" => 1,
    #         "message" => ""
    #     },
    #      "Files" => {
    #            "type" => "list",
    #         "content" => [
    #             [0] {
    #                       "name" => "Tropo.pdf",
    #                       "size" => 646768,
    #                  "extension" => "pdf",
    #                       "uuid" => "CwPx31xjl9k7Cp",
    #                      "pages" => 101,
    #                 "contentmd5" => "fd898b168b9780212a2ddd5bfbd79d65",
    #                   "mimetype" => "application/pdf",
    #                    "created" => "2011-01-17 19:28:05"
    #             }
    #         ]
    #     }
    #   }
    def list_fax_files
      resource = @base_resource + "/ListFaxFiles" + @api_credentials
      get(resource)
    end

    ##
    # Returns the recipients associated to the current faxjob
    # 
    # @return [Array] an array of hashes of recipients
    #
    # @example listing recipients on a fax job
    #   pamfaxr.list_recipients
    #
    #   returns:
    #
    #   {
    #         "result" => {
    #            "code" => "success",
    #           "count" => 1,
    #         "message" => ""
    #     },
    #     "Recipients" => {
    #            "type" => "list",
    #         "content" => [
    #                 {
    #                               "price" => 0,
    #                            "duration" => 0,
    #                                "name" => "",
    #                    "delivery_started" => nil,
    #                      "price_per_page" => 0.09,
    #                              "number" => "+13035551212",
    #                        "price_source" => "PNR",
    #                             "country" => "US",
    #                                "sent" => nil,
    #                           "completed" => nil,
    #                           "area_code" => "303",
    #                    "formatted_number" => "+1 303 5551212",
    #                                "zone" => "1",
    #                                "uuid" => "ExozS0NJe7CErm",
    #                       "currency_rate" => "1",
    #                               "pages" => nil,
    #                         "status_code" => 0,
    #                         "number_type" => "FIXED",
    #                 "transmission_report" => "",
    #                            "currency" => "1",
    #                         "description" => "Colorado (CO)",
    #                             "updated" => "2011-01-17 19:28:16",
    #                      "status_message" => nil,
    #                             "created" => "2011-01-17 19:28:16",
    #                               "state" => "unknown"
    #             },
    #                 {
    #                               "price" => 0,
    #                            "duration" => 0,
    #                                "name" => "",
    #                    "delivery_started" => nil,
    #                      "price_per_page" => 0.09,
    #                              "number" => "+14155551212",
    #                        "price_source" => "PNR",
    #                             "country" => "US",
    #                                "sent" => nil,
    #                           "completed" => nil,
    #                           "area_code" => "415",
    #                    "formatted_number" => "+1 415 5551212",
    #                                "zone" => "1",
    #                                "uuid" => "yoAT88QXAda80g",
    #                       "currency_rate" => "1",
    #                               "pages" => nil,
    #                         "status_code" => 0,
    #                         "number_type" => "FIXED",
    #                 "transmission_report" => "",
    #                            "currency" => "1",
    #                         "description" => "California (CA)",
    #                             "updated" => "2011-01-17 19:28:14",
    #                      "status_message" => nil,
    #                             "created" => "2011-01-17 19:28:14",
    #                               "state" => "unknown"
    #             }
    #         ]
    #     }
    #   }
    def list_recipients
      resource = @base_resource + "/ListRecipients" + @api_credentials
      get(resource)
    end
    
    ##
    # Sets the current fax cover sheet
    #
    # @param [String] the template ID to use
    # @param [String] the text to use in the template
    #
    # @return [Hash] the result of the set fax cover request
    #
    # @example set the cover for the fax
    #   pamfaxr.set_cover('3', 'Foobar is here!')
    #
    #   returns:
    #
    #   {
    #     "result" => {
    #            "code" => "success",
    #           "count" => 0,
    #         "message" => ""
    #     }
    #   }
    def set_cover(template_id, text)
      resource = URI.encode(@base_resource + "/SetCover" + @api_credentials + "&template_id=#{template_id}&text=#{text}")
      get(resource)
    end
    
    ##
    # Obtains the state of the FaxJob build, may block or return immediately
    #
    # @param [Hash] params the options for obtaining the fax state
    # @option params [optional, Boolean] :blocking true if you want to block until the FaxJob is ready, otherwise it returns the current state
    # @option params [optional, Integer] :interval the time to wait, in seconds, between each check of the status
    #
    # @return [Hash] the result of the status request
    #
    # @example get the state of the fax
    #   pamfaxr.get_state
    #
    #   returns:
    #
    #   {
    #           "result" => {
    #            "code" => "success",
    #           "count" => 2,
    #         "message" => ""
    #     },
    #       "converting" => false,
    #            "Files" => {
    #            "type" => "list",
    #         "content" => [
    #             [0] {
    #                 "file_order" => 0,
    #                      "state" => "converted"
    #             }
    #         ]
    #     },
    #     "FaxContainer" => {
    #                      "price" => 18.36,
    #                   "sms_cost" => 0,
    #                  "send_mail" => "0",
    #                       "uuid" => "ebKVV4XGwx99Wu",
    #         "error_notification" => "0",
    #         "group_notification" => "0",
    #                   "send_sms" => "0",
    #              "currency_rate" => 1,
    #          "cover_page_length" => "1",
    #                  "send_chat" => "0",
    #                      "pages" => 102,
    #                   "cover_id" => 3,
    #                   "currency" => true,
    #           "affiliatepartner" => nil,
    #                    "updated" => "2011-01-17 19:28:22",
    #                 "cover_text" => "Foobar is here!",
    #         "processing_started" => nil,
    #                    "created" => "2011-01-17 19:27:57",
    #                      "state" => "ready_to_send"
    #     }
    #   }
    def get_state(options={})
      if options[:blocking]
        state = nil
        result = nil
        while state == nil
          result = fetch_state
          sleep options[:interval]
        end
        result
      else
        fetch_state
      end
    end
    
    ##
    # Gets the preview of the pages
    #
    # @param [required, String] uuid of the fax to get the preview for
    # 
    # @return [Hash] the result of the preview request
    #
    # @example get a preview of the fax pages
    #   pamfaxr.get_preview('ebKVV4XGwx99Wu')
    #
    #   returns:
    #
    #   {
    #           "Status" => {
    #         "open" => 5,
    #         "done" => 0
    #     },
    #           "result" => {
    #            "code" => "success",
    #           "count" => 2,
    #         "message" => ""
    #     },
    #     "PreviewPages" => {
    #         "type" => "list"
    #     }
    #   }
    def get_preview(uuid)
      resource = URI.encode(@base_resource + "/GetPreview" + @api_credentials + "&uuid=#{uuid}")
      get(resource)
    end
    
    ##
    # Remove all of the files associated to a fax
    #
    # @param [required, String] uuid of the fax to remove all the files for
    #
    # @return [Hash] the result of the remove request
    #
    # @example remove all files
    #  pamfaxr.remove_all_files
    #
    #  returns:
    #
    #  {
    #     "result" => {
    #            "code" => "success",
    #           "count" => 0,
    #         "message" => ""
    #     }
    #  }
    def remove_all_files
      resource = URI.encode(@base_resource + "/RemoveAllFiles" + @api_credentials)
      get(resource)
    end
    
    ##
    # Remove all of the recipients associated to a fax
    #
    # @param [required, String] uuid of the fax to remove all the recipients for
    #
    # @return [Hash] the result of the remove request
    #
    # @example remove all recipients
    #  pamfaxr.remove_all_recipients
    #
    #  returns:
    #
    #  {
    #     "result" => {
    #            "code" => "success",
    #           "count" => 0,
    #         "message" => ""
    #     }
    #  }
    def remove_all_recipients
      resource = URI.encode(@base_resource + "/RemoveAllRecipients" + @api_credentials)
      get(resource)
    end
    
    ##
    # Remove all the cover page for the associated fax
    #
    # @param [required, String] uuid of the fax to remove the cover page for
    #
    # @return [Hash] the result of the remove request
    #
    # @example remove cover
    #  pamfaxr.remove_cover
    #
    #  returns:
    #
    #  {
    #     "result" => {
    #            "code" => "success",
    #           "count" => 0,
    #         "message" => ""
    #     }
    #  }
    def remove_cover
      resource = URI.encode(@base_resource + "/RemoveCover" + @api_credentials)
      get(resource)
    end
    
    ##
    # Remove a particular file associated to a fax
    #
    # @param [required, String] uuid of the fax to remove the particular file for
    #
    # @return [Hash] the result of the remove request
    #
    # @example remove file
    #  pamfaxr.remove_file('JNMi19AeQ6QkoC')
    #
    #  returns:
    #
    #  {
    #     "result" => {
    #            "code" => "success",
    #           "count" => 0,
    #         "message" => ""
    #     }
    #  }
    def remove_file(file_uuid)
      resource = URI.encode(@base_resource + "/RemoveFile" + @api_credentials + "&file_uuid=#{file_uuid}")
      get(resource)
    end
    
    ##
    # Remove a particular recipient associated to a fax
    #
    # @param [required, String] uuid of the fax to remove a particular recipients for
    #
    # @return [Hash] the result of the remove request
    #
    # @example TBD
    def remove_recipient(recipient_uuid)
      resource = URI.encode(@base_resource + "/RemoveRecipient" + @api_credentials + "&uuid=#{uuid}")
      get(resource)
    end
    
    ##
    # Request to send the built fax
    # 
    # @return [Hash] the result of the request to send the built fax
    #
    # @example send a fax
    #   pamfaxr.send_fax
    #   
    #   returns:
    #
    #   {
    #     "result" => {
    #            "code" => "not_enough_credit",
    #           "count" => 0,
    #         "message" => "You don't have enough PamFax Credit. <a href=\\\"https://www.pamfax.biz/shop\\\">Buy PamFax Credit now</a>."
    #     }
    #   }
    def send_fax
      resource = @base_resource + "/Send" + @api_credentials
      get(resource)
    end

    ##
    # Request to send the built fax later
    # 
    # @return [Hash] the result of the request to send the built fax later
    #
    # @example
    #   pamfaxr.send_fax_later
    #
    #   returns:
    #
    #   {
    #     "result" => {
    #            "code" => "success",
    #           "count" => 0,
    #         "message" => ""
    #     }
    #   }    
    def send_fax_later
      resource = @base_resource + "/SendLater" + @api_credentials
      get(resource)
    end
    
    ##
    # Captures any unknown methods gracefully by throwing a Runtime Error
    def method_missing(method, *args)
      raise RuntimeError, "Unknown method #{method}"
    end
    
    private
    
    ##
    # Fetches the state of the fax job
    #
    # @return [Hash] the status of the current fax job
    def fetch_state
      resource = @base_resource + "/GetFaxState" + @api_credentials
      fax_state = JSON.parse @http.get(resource).body
      fax_state.merge!('converting' => converting?(fax_state))
      fax_state
    end

    ##
    # Returns whether or not a file in the fax job is still in a converting state
    #
    # @param [required, Hash] the hash returned by fetch_state
    #
    # @return [Boolean] true if a file is still in the converting process
    def converting?(fax_state)
      converting = false
      fax_state['Files']['content'].each { |file| converting = true if file['state'] == '' || file['state'] == 'converting' }
      converting
    end
    
    ##
    # Gets the resource
    #
    # @param [required, String] resource to get
    # @return [Hash] the result of the request
    def get(resource)
      begin
        body = @http.get(resource, { 'Content-Type' => 'application/json' }).body
        JSON.parse body
      rescue => error
      end
    end
    
    ##
    # Posts to the resource
    #
    # @param [required, String] resource to post
    # @param [requried, String] data of the body to post
    # @param [required, Hash] headers to send with the post request
    #
    # @return [Hash] the result of the request
    def post(resource, data, headers={})
      begin
        result, body = @http.post(resource, data, headers)
        JSON.parse body
      rescue => error
      end
    end
  end
  
  ##
  # Creates an instance of the PamFax class
  #
  # @param [Hash] params the options for instantiating a PamFax class
  # @option params [optionsl, String] :base_uri the URI of the PamFax API, it defaults to https://api.pamfax.biz
  # @option params [String] :key the PamFax API key you have been assigned
  # @option params [String] :secret the PamFax API secret you have been assigned
  # @option params [String] :username the PamFax username you are going to use to send faxes
  # @option params [String] :password the PamFax password you are going to use to send faxes
  #
  # @return [Object] the instantiated FaxJob class
  #
  # @example create a new PamFax object
  #   pamfaxr = PamFax.new({ :key => 'your_api_key', :secret => 'your_api_secret' })
  def initialize(options={})
    base_uri = options[:base_uri] || "https://api.pamfax.biz"
    
    options.merge!({ :http            => create_http(URI.parse(base_uri)),
                     :api_credentials => "?apikey=#{options[:key]}&apisecret=#{options[:secret]}&apioutputformat=API_FORMAT_JSON" })
    options[:api_credentials] = options[:api_credentials] + "&usertoken=#{get_user_token(options)}"
    
    @fax_job = FaxJob.new options
  end
  
  ##
  # Captures the request for the fax job and sends them to the instantiated FaxJob object
  def method_missing(method, *args)
    @fax_job.send(method, *args)
  end
  
  private 
  
  ##
  # Gets the user token to use with subsequent requests
  #
  # @param [Hash] params the options for getting the user token
  # @option params [String] :api_credentials the PamFax credentials built with key/secret
  # @option params [String] :username the PamFax username you are going to use to send faxes
  # @option params [String] :password the PamFax password you are going to use to send faxes
  #
  # @return [Object] the instantiated FaxJob class
  def get_user_token(options={})
    result = verify_user(options)
    if result['result']['code'] == 'success'
      result['UserToken']['token']
    else
      raise RuntimeError, result['result']['message']
    end
  end
  
  ##
  # Calls the VerifyUser resource to fetch the verified user details
  #
  # @param [Hash] params the options for verifying the user
  # @option params [String] :api_credentials the PamFax credentials built with key/secret
  # @option params [String] :username the PamFax username you are going to use to send faxes
  # @option params [String] :password the PamFax password you are going to use to send faxes
  #
  # @return [Object] the instantiated FaxJob class
  def verify_user(options={})
    resource = "/Session/VerifyUser/#{options[:api_credentials]}&username=#{options[:username]}&password=#{options[:password]}"
    body = options[:http].get(resource).body 
    JSON.parse body
  end
  
  ##
  # Creates an ssl enabled net/http object
  # 
  # @param [String] the URL to use to connect to the service
  #
  # @return [Object] an instantiated net/http object that is ssl enabled
  def create_http(base_uri)
    http = Net::HTTP.new(base_uri.host, base_uri.port)
    http.use_ssl = true
    http
  end
end