require 'uri'
require 'net/http'
require "rbconfig"

require 'bundler'
Bundler.require

################################
# Set the constants
################################
MASTERCODE = "12345abc"
APPNAME = "flashair"
################################
 

class Flashair
  def initialize(mastercode=MASTERCODE,appname=APPNAME,updir=nil)
    osn = RbConfig::CONFIG["target_os"].downcase
    @mastercode = mastercode
    @appname = appname
    @updir = updir
    # check the Flashair
    @base_url = @appname + (osn =~ /darwin/ ? ".local" : "")
    raise("Your FlashAir is down or unreachable.") unless Net::Ping::External.new(@base_url).ping?
    
    @base_url = "http://" + @base_url
  end
  
  # time should be Time object
  def upload(file_name,time=nil)
    time = time_to_fattime(time ? time : Time.now)
    
    if RestClient.get(@base_url + "/upload.cgi?WRITEPROTECT=ON&UPDIR=/#{@updir}&FTIME=#{time}") == "SUCCESS"
      sleep(1)
      doc = Nokogiri::HTML.parse(RestClient.post(@base_url + "/upload.cgi", :name_of_file_param => File.new(file_name)))
      
      if doc.css("h1").first.text == "Success"
        sleep(3)
        if RestClient.get(@base_url + "/upload.cgi?WRITEPROTECT=OFF") == "SUCCESS"
          1
        else
          nil
        end
      else
        nil
      end
    else
      nil
    end
      
  end
  
  private
    def time_to_fattime(time)
      y = (time.year - 1980) << 9
      mon = (time.month) << 5
      d = time.day
      h = time.hour << 11
      min = time.min << 5
      s = (time.sec/2).to_i
      ts = "0x" + (y + mon + d).to_s(16) + (h + min + s).to_s(16)
    end
end