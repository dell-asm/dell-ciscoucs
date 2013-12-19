require 'rest_client'
require 'rexml/document'

module PuppetX::Puppetlabs::Transport
  class Authenticate
    def initialize(url, username, password)
      @url = url
      @username = username
      @password = password
    end

    def login
      connectionxml = '<aaaLogin inName="' + @username + '" inPassword="'+ @password +'"/>'
      responsexml = RestClient.post @url, connectionxml, :content_type => 'text/xml'
      # Create an XML doc and parse it to get the cookie.
      logindoc = REXML::Document.new(responsexml)
      root = logindoc.root
      @cookie = root.attributes['outCookie']
    end

    def refresh
      refresh_xml = '<aaaTokenLogin inName="#{@username}" inToken="#{@cookie}" />'
      responsexml ||= RestClient.post @url, refresh_xml, :content_type => 'text/xml'
      Puppet.debug responsexml
      # Create an XML doc and parse it to get the cookie.
      refreshdoc = REXML::Document.new(responsexml)
      root = refreshdoc.root
      @cookie = root.attributes['outCookie']

      #TODO- store cookie in file per IPAddress

    end

    def logout
      Puppet.debug("#{self.class} closing connection to:  #{@host}")
      closexml ='<aaaLogout inCookie="#{@cookie}"/>'
      RestClient.post @url, closexml, :content_type => 'text/xml'
    end

    def getcookie
      unless @cookie
        login
      else
        refresh
        if !@cookie
          login
        end
      end
      return @cookie
    end
  end
end
