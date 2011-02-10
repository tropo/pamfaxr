require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

PAMFAX_URI        = 'https://sandbox-api.pamfax.biz'
PAMFAX_API_KEY    = 'name'
PAMFAX_API_SECRET = 'abd123'
PAMFAX_USERNAME   = 'fooey'
PAMFAX_PASSWORD   = 'foobar'

FakeWeb.allow_net_connect = false

describe "PamFaxr" do
  before(:all) do
    
    @user_found = { "result" => 
                    { "code"                => "success", 
                      "count"               => 2, 
                      "message"             => "" }, 
                    "User"                  => 
                     { "name"               => "Tropo", 
                       "affiliatepartnerid" => 154, 
                       "free_credit"        => 0, 
                       "uuid"               => "yAS5AOLr4SKqAJ", 
                       "username"           => "tropo-test", 
                       "credit"             => 0, 
                       "is_member"          => 0, 
                       "email"              => "jsgoecke@voxeo.com",
                       "created"            => "2010-10-21 15:22:49" }, 
                     "UserToken"            => { "token" => "m3cv0d9gqb69taajcu76nqv5eccht76t" } }

    @user_not_found = { "result" => 
                        { "code"    => "user_not_found", 
                          "count"   => 0, 
                          "message" => "Unknown user name or incorrect password" } }
    
    @create_result = { "result" => 
                       { "code"                 => "success", 
                         "count"                => 1, 
                         "message"              => ""}, 
                       "FaxContainer"           => 
                         { "price"              => 0, 
                           "send_mail"          => 0, 
                           "uuid"               => "x0RXuwLhP7qKU2", 
                           "error_notification" => 0, 
                           "group_notification" => 0, 
                           "send_sms"           => 0, 
                           "currency_rate"      => 0.7712, 
                           "cover_page_length"  => nil, 
                           "send_chat"          => 0, 
                           "pages"              => nil, 
                           "cover_id"           => 0, 
                           "currency"           => "USD", 
                           "affiliatepartner"   => "154", 
                           "updated"            => nil, 
                           "cover_text"         => nil, 
                           "processing_started" => nil, 
                           "created"            => "2010-10-22 14:13:57", 
                           "state"              => "editing" } }
                                   
    @add_recipient_result = { "result" => 
                             { "code"                  => "success", 
                               "count"                 => 1, 
                               "message"               => "" }, 
                             "FaxRecipient"            => 
                               { "price"               => 0, 
                                 "duration"            => 0, 
                                 "name"                => "", 
                                 "delivery_started"    => nil, 
                                 "price_per_page"      => 0.12, 
                                 "number"              => "+14155551212", 
                                 "price_source"        => "PNR", 
                                 "country"             => "US", 
                                 "sent"                => nil, 
                                 "completed"           => nil, 
                                 "area_code"           => "415", 
                                 "zone"                => "1", 
                                 "uuid"                => "6WSLyy0ophkgoO", 
                                 "currency_rate"       => "0.7712", 
                                 "id"                  => 18164, 
                                 "pages"               => nil, 
                                 "status_code"         => 0, 
                                 "number_type"         => "FIXED", 
                                 "transmission_report" => "", 
                                 "currency"            => "USD", 
                                 "description"         => "California (CA)", 
                                 "updated"             => "2010-10-22 14:24:44", 
                                 "status_message"      => nil, 
                                 "created"             => "2010-10-22 14:24:44", 
                                 "state"               => "unknown"} }
                                   
    @state = {
                       "result" => {
                        "code" => "success",
                       "count" => 2,
                     "message" => ""
                 },
                   "converting" => true,
                        "Files" => {
                        "type" => "list",
                     "content" => [
                             {
                             "file_order" => 0,
                                  "state" => "converting"
                         },
                             {
                             "file_order" => 1,
                                  "state" => "converting"
                         }
                     ]
                 },
                 "FaxContainer" => {
                                  "price" => 0,
                               "sms_cost" => 0,
                              "send_mail" => "0",
                                   "uuid" => "mVRLR725Ei1zhU",
                     "error_notification" => "0",
                     "group_notification" => "0",
                               "send_sms" => "0",
                          "currency_rate" => 1,
                      "cover_page_length" => "1",
                              "send_chat" => "0",
                                  "pages" => nil,
                               "cover_id" => 3,
                               "currency" => "1",
                       "affiliatepartner" => nil,
                                "updated" => "2011-01-17 18:27:27",
                             "cover_text" => "Foobar is here!",
                     "processing_started" => nil,
                                "created" => "2011-01-17 18:27:08",
                                  "state" => "editing"
                 }
             }
    
    @available_covers = { "result"                 => 
                          { "code"                 => "success", 
                            "count"                => 1, 
                            "message"              => "" }, 
                            "Covers"               => 
                              { "type"             => "list", 
                                "content"          =>
                                  [{ "title"       => "(none)", 
                                     "creator"     => 0, 
                                     "id"          => 0, 
                                     "thumb_id"    => "0266e33d3f546cb5436a10798e657d97", 
                                     "preview_id"  => "9188905e74c28e489b44e954ec0b9bca"}, 
                                   { "template_id" => "eae27d77ca20db309e056e3d2dcd7d69",
                                     "title"       => "Basic", 
                                     "creator"     => 0, 
                                     "id"          => 1, 
                                     "thumb_id"    => "091d584fced301b442654dd8c23b3fc9", 
                                     "description" => nil, 
                                     "preview_id"  => "7eabe3a1649ffa2b3ff8c02ebfd5659f" }, 
                                   { "template_id" => "ca46c1b9512a7a8315fa3c5a946e8265", 
                                     "title"       => "Flowers", 
                                     "creator"     => 0, 
                                     "id"          => 3, 
                                     "thumb_id"    => "45fbc6d3e05ebd93369ce542e8f2322d", 
                                     "description" => nil, 
                                     "preview_id"  => "979d472a84804b9f647bc185a877a8b5" }, 
                                   { "template_id" => "e96ed478dab8595a7dbda4cbcbee168f", 
                                     "title"       => "Message", 
                                     "creator"     => 0, 
                                     "id"          => 4, 
                                     "thumb_id"    => "ec8ce6abb3e952a85b8551ba726a1227", 
                                     "description" => nil, 
                                     "preview_id"  => "63dc7ed1010d3c3b8269faf0ba7491d4" }, 
                                   { "template_id" => "f340f1b1f65b6df5b5e3f94d95b11daf", 
                                     "title"       => "Simple", 
                                     "creator"     => 0, 
                                     "id"          => 5, 
                                     "thumb_id"    => "335f5352088d7d9bf74191e006d8e24c", 
                                     "description" => nil, 
                                     "preview_id"  => "cb70ab375662576bd1ac5aaf16b3fca4" }] } }
                                     
    @page =  {
                            "result" => {
                         "code" => "success",
                        "count" => 1,
                      "message" => ""
                  },
                  "FaxContainerFile" => {
                            "name" => "Tropo.pdf",
                      "file_order" => 0,
                             "ext" => "pdf",
                       "file_uuid" => "OQskZYr9D0MANw",
                            "mime" => "application/pdf",
                           "state" => ""
                  }
              }
    
    @local_file_upload = {
                                        "result" => {
                                     "code" => "success",
                                    "count" => 1,
                                  "message" => ""
                              },
                              "FaxContainerFile" => {
                                        "name" => "Tropo.pdf",
                                  "file_order" => 0,
                                         "ext" => "pdf",
                                   "file_uuid" => "OuH2JbbGKhDp8o",
                                        "mime" => "application/pdf",
                                       "state" => ""
                              }
                          }
    
    @no_files = {
                    "result" => {
                           "code" => "no_files_in_fax",
                          "count" => 0,
                        "message" => "No files in fax found"
                    }
                }
                
    @fax_files = {
                      "result" => {
                             "code" => "success",
                            "count" => 1,
                          "message" => ""
                      },
                       "Files" => {
                             "type" => "list",
                          "content" => [
                                  {
                                        "name" => "Tropo.pdf",
                                        "size" => 646768,
                                   "extension" => "pdf",
                                        "uuid" => "aMzeebWS9O8GKz",
                                       "pages" => 0,
                                  "contentmd5" => "fd898b168b9780212a2ddd5bfbd79d65",
                                    "mimetype" => "application/pdf",
                                     "created" => "2011-01-17 14:55:57"
                              },
                                  {
                                        "name" => "examples/Tropo.pdf",
                                        "size" => 646768,
                                   "extension" => "pdf",
                                        "uuid" => "BVMJzRmu1zAlSZ",
                                       "pages" => 0,
                                  "contentmd5" => "fd898b168b9780212a2ddd5bfbd79d65",
                                    "mimetype" => "application/pdf",
                                     "created" => "2011-01-17 14:56:02"
                              }
                          ]
                      }
                  }
    
    
    @recipients = {
                          "result" => {
                             "code" => "success",
                            "count" => 1,
                          "message" => ""
                      },
                      "Recipients" => {
                             "type" => "list",
                          "content" => [
                                  {
                                                "price" => 0,
                                             "duration" => 0,
                                                 "name" => "",
                                     "delivery_started" => nil,
                                       "price_per_page" => 0.09,
                                               "number" => "+14155551212",
                                         "price_source" => "PNR",
                                              "country" => "US",
                                                 "sent" => nil,
                                            "completed" => nil,
                                            "area_code" => "415",
                                     "formatted_number" => "+1 415 5551212",
                                                 "zone" => "1",
                                                 "uuid" => "4x4W2JDn29HOR6",
                                        "currency_rate" => "1",
                                                "pages" => nil,
                                          "status_code" => 0,
                                          "number_type" => "FIXED",
                                  "transmission_report" => "",
                                             "currency" => "1",
                                          "description" => "California (CA)",
                                              "updated" => "2011-01-17 14:56:04",
                                       "status_message" => nil,
                                              "created" => "2011-01-17 14:56:04",
                                                "state" => "unknown"
                              }
                          ]
                      }
                  }
                
    @success = {
                    "result" => {
                           "code" => "success",
                          "count" => 0,
                        "message" => ""
                    }
                }
           
    @fax_preview = {
                          "Status" => {
                            "open" => 5,
                            "done" => 0
                        },
                              "result" => {
                               "code" => "success",
                              "count" => 2,
                            "message" => ""
                        },
                        "PreviewPages" => {
                            "type" => "list"
                        }
                    }

    FakeWeb.register_uri(:get, 
                         "https://sandbox-api.pamfax.biz/Session/VerifyUser/?apikey=#{PAMFAX_API_KEY}&apisecret=#{PAMFAX_API_SECRET}&apioutputformat=API_FORMAT_JSON&username=#{PAMFAX_USERNAME}&password=#{PAMFAX_PASSWORD}", 
                         :body => @user_found.to_json, 
                         :content_type => "application/json")

    FakeWeb.register_uri(:get, 
                         "https://api.pamfax.biz/Session/VerifyUser/?apikey=tropo_developer&apisecret=7xGi0xAqcg3YXw&apioutputformat=API_FORMAT_JSON&username=fooey&password=looey", 
                         :body => @user_found.to_json, 
                         :content_type => "application/json")

    FakeWeb.register_uri(:get, 
                         "https://sandbox-api.pamfax.biz/Session/VerifyUser/?apikey=tropo&apisecret=abc123&apioutputformat=API_FORMAT_JSON&username=fooey&password=looey", 
                         :body => @user_not_found.to_json, 
                         :content_type => "application/json")
    
    FakeWeb.register_uri(:get, 
                         %r|https://sandbox-api.pamfax.biz/FaxJob/Create|, 
                         :body => @create_result.to_json,
                         :content_type => "application/json")

    FakeWeb.register_uri(:get, 
                         %r|https://sandbox-api.pamfax.biz/FaxJob/AddRecipient|, 
                         :body => @add_recipient_result.to_json,
                         :content_type => "application/json")

    FakeWeb.register_uri(:get, 
                         "https://sandbox-api.pamfax.biz/FaxJob/GetFaxState?apikey=name&apisecret=abd123&apioutputformat=API_FORMAT_JSON&usertoken=m3cv0d9gqb69taajcu76nqv5eccht76t", 
                         :body => @state.to_json,
                         :content_type => "application/json")

    FakeWeb.register_uri(:get, 
                         %r|https://sandbox-api.pamfax.biz/FaxJob/Send|, 
                         :body => @no_files.to_json,
                         :content_type => "application/json")

    FakeWeb.register_uri(:get, 
                          "https://sandbox-api.pamfax.biz/FaxJob/ListAvailableCovers?apikey=name&apisecret=abd123&apioutputformat=API_FORMAT_JSON&usertoken=m3cv0d9gqb69taajcu76nqv5eccht76t", 
                          :body => @available_covers.to_json,
                          :content_type => "application/json")
                                    
    FakeWeb.register_uri(:post, 
                         "https://sandbox-api.pamfax.biz/FaxJob/AddFile?apikey=name&apisecret=abd123&apioutputformat=API_FORMAT_JSON&usertoken=m3cv0d9gqb69taajcu76nqv5eccht76t",
                         :body => @local_file_upload.to_json,
                         :content_type => "application/json",
                         :status => ["200", "OK"])
                          
    FakeWeb.register_uri(:get, 
                         "https://sandbox-api.pamfax.biz/FaxJob/SetCover?apikey=name&apisecret=abd123&apioutputformat=API_FORMAT_JSON&usertoken=m3cv0d9gqb69taajcu76nqv5eccht76t&template_id=f340f1b1f65b6df5b5e3f94d95b11daf&text=Hi%20foobar!",
                         :body => ({ "result" => { "code" => "success", "count" => 0, "message" => "" } }).to_json,
                         :content_type => "application/json",
                         :status => ["200", "OK"])

   FakeWeb.register_uri(:get, 
                        "https://sandbox-api.pamfax.biz/FaxJob/AddRemoteFile?apikey=name&apisecret=abd123&apioutputformat=API_FORMAT_JSON&usertoken=m3cv0d9gqb69taajcu76nqv5eccht76t&url=https://s3.amazonaws.com/pamfax-test/Tropo.pdf",
                        :body => @page.to_json,
                        :content_type => "application/json",
                        :status => ["200", "OK"])
                        
    FakeWeb.register_uri(:get, 
                          "https://sandbox-api.pamfax.biz/FaxJob/ListFaxFiles?apikey=name&apisecret=abd123&apioutputformat=API_FORMAT_JSON&usertoken=m3cv0d9gqb69taajcu76nqv5eccht76t",
                          :body => @fax_files.to_json,
                          :content_type => "application/json",
                          :status => ["200", "OK"])

    FakeWeb.register_uri(:get, 
                          "https://sandbox-api.pamfax.biz/FaxJob/ListRecipients?apikey=name&apisecret=abd123&apioutputformat=API_FORMAT_JSON&usertoken=m3cv0d9gqb69taajcu76nqv5eccht76t",
                          :body => @recipients.to_json,
                          :content_type => "application/json",
                          :status => ["200", "OK"])

    FakeWeb.register_uri(:get, 
                          "https://sandbox-api.pamfax.biz/FaxJob/Cancel?apikey=name&apisecret=abd123&apioutputformat=API_FORMAT_JSON&usertoken=m3cv0d9gqb69taajcu76nqv5eccht76t&uuid=JfTenDWumWZZBq",
                          :body => @success.to_json,
                          :content_type => "application/json",
                          :status => ["200", "OK"])

    FakeWeb.register_uri(:get, 
                          "https://sandbox-api.pamfax.biz/FaxJob/GetPreview?apikey=name&apisecret=abd123&apioutputformat=API_FORMAT_JSON&usertoken=m3cv0d9gqb69taajcu76nqv5eccht76t&uuid=JfTenDWumWZZBq",
                          :body => @fax_preview.to_json,
                          :content_type => "application/json",
                          :status => ["200", "OK"])

    FakeWeb.register_uri(:get, 
                          "https://sandbox-api.pamfax.biz/FaxJob/GetPreview?apikey=name&apisecret=abd123&apioutputformat=API_FORMAT_JSON&usertoken=m3cv0d9gqb69taajcu76nqv5eccht76t&uuid=JfTenDWumWZZBq",
                          :body => @fax_preview.to_json,
                          :content_type => "application/json",
                          :status => ["200", "OK"])

    FakeWeb.register_uri(:get, 
                          %r|https://sandbox-api.pamfax.biz/FaxJob/Remove|,
                          :body => @success.to_json,
                          :content_type => "application/json",
                          :status => ["200", "OK"])
                                                                          
    # Our testing URI
    @pamfaxr = PamFaxr.new :base_uri     => PAMFAX_URI,
                           :api_key      => PAMFAX_API_KEY, 
                           :api_secret   => PAMFAX_API_SECRET, 
                           :username     => PAMFAX_USERNAME, 
                           :password     => PAMFAX_PASSWORD

  end
  
  it "should create an instance of PamFax" do
    @pamfaxr.instance_of?(PamFaxr).should == true
  end
  
  it "should create an instance of PamFax without the base_uri, api_key or api_secret included" do
    pamfaxr = PamFaxr.new :username     => 'fooey', 
                          :password     => 'looey'
    pamfaxr.instance_of?(PamFaxr).should == true
  end
  
  it "should get an error if invalid user details are requested" do
    begin
      pamfax = PamFaxr.new :base_uri     => PAMFAX_URI,
                           :api_key      => 'tropo', 
                           :api_secret   => 'abc123', 
                           :username     => 'fooey', 
                           :password     => 'looey'
    rescue => e
      e.to_s.should == "Unknown user name or incorrect password"
    end
  end
  
  it "should raise an error if an unknown method is called" do
    begin
      @pamfaxr.foobar
    rescue => e
      e.to_s.should == 'Unknown method foobar'
    end
  end
  
  it "should create a new fax instance" do
    @pamfaxr.create_fax_job.should == @create_result
  end
  
  it "should create a new fax receipient" do
    @pamfaxr.add_recipient('+14155551212').should == @add_recipient_result
  end
  
  it "should add a new fax cover" do
    @pamfaxr.set_cover('f340f1b1f65b6df5b5e3f94d95b11daf', 'Hi foobar!').should == { "result" => { "code" => "success", "count" => 0, "message" => "" } }
  end
  
  it "should return the fax state when no files attached" do
    @pamfaxr.get_state.should == @state
  end
  
  it "should reject the fax send request if no pages added" do
    @pamfaxr.send_fax.should == @no_files
  end
  
  it "should add a file to the fax job" do
    @pamfaxr.add_remote_file('https://s3.amazonaws.com/pamfax-test/Tropo.pdf').should == @page
    @pamfaxr.add_file('examples/Tropo.pdf').should == @local_file_upload
  end
  
  it "should list the available fax cover templates" do
    @pamfaxr.list_available_covers.should == @available_covers
  end
  
  it 'should list the assoicated files' do
    @pamfaxr.list_fax_files.should == @fax_files
  end
  
  it 'should list the recipients' do
    @pamfaxr.list_recipients.should == @recipients
  end
  
  it 'should cancel an outstanding fax request' do
    @pamfaxr.cancel('JfTenDWumWZZBq').should == @success
  end
  
  it 'should clone a fax' do
    pending('Can not send from the sandbox, so fax is never in a state to see a valid response.')
  end
  
  it 'should allow us to preview all of the pages' do
    @pamfaxr.get_preview('JfTenDWumWZZBq').should == @fax_preview
  end
  
  it 'should send the fax later' do
    @pamfaxr.send_fax_later.should == @no_files
  end
  
  describe 'remove' do
    it 'should remove all files' do
      @pamfaxr.remove_all_files.should == @success
    end
    
    it 'should remove all recipients' do
      @pamfaxr.remove_all_recipients.should == @success
    end
    
    it 'should remove the cover' do
      @pamfaxr.remove_cover.should == @success
    end
    
    it 'should remove the cover' do
      @pamfaxr.remove_file('1234').should == @success
    end
  end
end