require 'rest_client'
require 'rexml/document'

ucs_module = Puppet::Module.find('ciscoucs', Puppet[:environment].to_s)
require File.join ucs_module.path, 'lib/puppet_x/util/ciscoucs/nested_hash'
require File.join ucs_module.path, 'lib/puppet_x/util/ciscoucs/xml_formatter'

module PuppetX::Puppetlabs::Transport
  # "Base class for authenticate"
  class Authenticate
    def initialize(url, username, password)
      @url = url
      @username = username
      @password = password
    end

    def login
      formatter = PuppetX::Util::Ciscoucs::Xml_formatter.new("aaaLogin")
      parameters = PuppetX::Util::Ciscoucs::NestedHash.new
      parameters['/aaaLogin'][:inName] = @username
      parameters['/aaaLogin'][:inPassword] = @password
      requestxml = formatter.command_xml(parameters)
      responsexml = RestClient.post @url, requestxml, :content_type => 'text/xml'
      # Create an XML doc and parse it to get the cookie.
      # check if response xml has come
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
