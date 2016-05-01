require 'rest-client'
require 'nokogiri'
require 'open-uri'

response = RestClient::Request.execute(:method => :get, :url => 'http://www.reddit.com/r/wallpapers/hot', :headers => {"User-Agent" => "johnsbot"})

object = Nokogiri::HTML(response.body)

def this_is_gross(object)
  object.css("div").select {|div| div['id'] =~ /thing_t.+/ }.each do |link|
      url =  link['data-url']
      extension = url[url.rindex(/\..+/)..url.length] unless !url.rindex(/\..+/)
      if extension == ".png" or extension == ".jpg" then
        File.open("temp#{extension}", 'w') do |save_file|
          open(url, 'rb') do |picture|
              save_file.write(picture.read)
              # puts "file written"
              return Dir.pwd + "/temp#{extension}"
          end
        end
      end
    end
end

path = this_is_gross(object)
puts path
system "gsettings set org.gnome.desktop.background picture-uri file://#{path}"
