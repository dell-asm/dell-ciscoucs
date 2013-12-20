require 'rest_client' if Puppet.features.restclient? and ! Puppet.run_mode.master?
require 'rexml/document'

# "Base class for ciscoucs device"  
class Puppet::Util::NetworkDevice::CiscoUCS::CiscoUCS
    #attr_accessor :cookie
    attr_reader :cookie
    def initialize(opts)
      @username    = opts[:username]
      @password    = opts[:password]
      @host     = option[:server]
      @url    = "https://#{@host}/nuova"
      #@rest||= RestClient::Resource.new(@url, :user => @username, :password => @password, :timeout => 300 )
      Puppet.debug("#{self.class} initializing connection to: #{@host}")
    end

    def connect
      if @transport
        # cookie exists, validate it.
        # if its not a valid cookie login again
        return @transport
      end
        # if no cookie exists, send login request to UCS Manager and get a new cookie
        login
    end
    
    def login
      connectionxml = '<aaaLogin inName="#{@username}" inPassword="#{@password}"/>'
      responsexml ||= RestClient.post @url, connectionxml, :content_type => 'text/xml'
      
      puts responsexml
      
      # Create an XML doc and parse it to get the cookie.
      logindoc = REXML::Document.new(responsexml)
      root = logindoc.root
      @transport = root.attributes['outCookie']
       puts "login in device.rb-----------" + @transport
    end
    
    def close
      Puppet.debug("#{self.class} closing connection to:  #{@host}")
      closexml ='<aaaLogout inCookie="#{ucsCookie}"/>'
      RestClient.post @url, closexml, :content_type => 'text/xml'
    end
  end

