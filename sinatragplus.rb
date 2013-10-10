# sinatragplus.rb
require 'sinatra'
require "sinatra/config_file"
require 'google_plus'

config_file 'config.yml'


error do
  erb :'500'
end

#class
class GPlus
  def initialize(apikey, gid)
    @apikey = apikey
    @gid = gid
    get_info
  end

  attr_reader :row0, :row1, :row2, :logo
  private
    #Get info about specific G+ ID
    def get_info
      GooglePlus.api_key = 'AIzaSyC5FFIdxj8ZoBHf3KnUU8clfWBmASc0ZOA'
      begin
        GooglePlus.api_key = @apikey
        person = GooglePlus::Person.get(@gid.to_i)
        @row0 = person.display_name
        @row1 = person.list_activities.items
        @row2 = person.url
        properties = person.attributes
        puts properties.class
        puts properties['image'].class
        @logo = properties['image']['url']
        properties.each { |key, value| puts "%-20s %20s" % [key, value] }
      rescue Exception => msg  
        # display the system generated error message  
        puts msg  
      end  
    end
end
 
# Display Google+ details
get '/' do
  @key = settings.key
  @user = settings.user
  @gplus = GPlus.new(@key, @user)
  erb :show
end

