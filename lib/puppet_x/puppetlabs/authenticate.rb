require 'rest_client' if Puppet.features.restclient? and ! Puppet.run_mode.master?

require 'rexml/document'

module PuppetX::Puppetlabs
  class Authenticate
    def initialize(url, username, password)
      @url = url
      @username = username
      @password = password
    end

    def login
      connectionxml = '<aaaLogin inName="#{@username}" inPassword="#{@password}"/>'
      responsexml ||= RestClient.post @url, connectionxml, :content_type => 'text/xml'
      puts responsexml
      # Create an XML doc and parse it to get the cookie.
      logindoc = REXML::Document.new(responsexml)
      root = logindoc.root
      @cookie = root.attributes['outCookie']
      puts "login in transport -----------" + @cookie
    end

    def refresh
      refresh_xml = '<aaaTokenLogin inName="#{@username}" inToken="#{@cookie}" />'
      responsexml ||= RestClient.post @url, refresh_xml, :content_type => 'text/xml'
      puts responsexml
      
      # Create an XML doc and parse it to get the cookie.
      refreshdoc = REXML::Document.new(responsexml)
      root = refreshdoc.root
      @cookie = root.attributes['outCookie']
      puts "refresh in transport -----------" + @cookie
      
      #TODO- store cokkie in file per IPAddress
      
    end

    def logout
      Puppet.debug("#{self.class} closing connection to:  #{@host}")
      closexml ='<aaaLogout inCookie="#{@cookie}"/>'
      RestClient.post @url, closexml, :content_type => 'text/xml'
    end
    
    def getCookie
      unless @cookie
        put "Cookie does not exists, login"
        login
      else
        put "Cookie does not exists, validate"
        refresh
        if ! @cookie
          login
        end
      end
    end
  end
end
