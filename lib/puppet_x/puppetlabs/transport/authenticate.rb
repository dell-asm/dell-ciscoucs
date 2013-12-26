require 'rest_client'
require 'rexml/document'

ucs_module = Puppet::Module.find('ciscoucs', Puppet[:environment].to_s)
require File.join ucs_module.path, 'lib/puppet_x/util/ciscoucs/nested_hash'
require File.join ucs_module.path, 'lib/puppet_x/util/ciscoucs/xml_formatter'

module PuppetX::Puppetlabs::Transport
  # "Base class for authenticate"
  @@cookie = ""
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
      if requestxml.to_s.strip.length == 0
        raise Puppet::Error, "Cannot create request xml for login operation"
      end
      responsexml = RestClient.post @url, requestxml, :content_type => 'text/xml'
      if responsexml.to_s.strip.length == 0
        raise Puppet::Error, "No response obtained from login operation"
      end
      # Create an XML doc and parse it to get the cookie.
      root = REXML::Document.new(responsexml).root
      if root.attributes['outCookie'].nil?
        raise Puppet::Error, "Cannot obtain cookie from response"
      end
      @@cookie = root.attributes['outCookie']
    end

    def refresh
      formatter = PuppetX::Util::Ciscoucs::Xml_formatter.new("aaaRefresh")
      parameters = PuppetX::Util::Ciscoucs::NestedHash.new
      parameters['/aaaRefresh'][:inName] = @username
      parameters['/aaaRefresh'][:inPassword] = @password
      parameters['/aaaRefresh'][:inCookie] = @@cookie
      requestxml = formatter.command_xml(parameters)
      if requestxml.to_s.strip.length == 0
        raise Puppet::Error, "Cannot create request xml for refresh operation"
      end
      responsexml = RestClient.post @url, requestxml, :content_type => 'text/xml'
      if responsexml.to_s.strip.length == 0
        raise Puppet::Error, "No response obtained from refresh operation"
      end
      # Create an XML doc and parse it to get the cookie.
      root = REXML::Document.new(responsexml).root
      if root.attributes['outCookie'].nil?
        raise Puppet::Error, "Cannot obtain cookie from response"
      end
      @@cookie = root.attributes['outCookie']
    end

    def logout
      Puppet.debug("#{self.class} closing connection to:  #{@host}")
      formatter = PuppetX::Util::Ciscoucs::Xml_formatter.new("aaaLogout")
      parameters = PuppetX::Util::Ciscoucs::NestedHash.new
      parameters['/aaaLogout'][:inCookie] = @@cookie
      requestxml = formatter.command_xml(parameters)
      if requestxml.to_s.strip.length == 0
        raise Puppet::Error, "Cannot create request xml for logout operation"
      end      
      responsexml = RestClient.post @url, requestxml, :content_type => 'text/xml'
      if responsexml.to_s.strip.length == 0
        raise Puppet::Error, "No response obtained from logout operation"
      end
      # Create an XML doc and parse it to get the cookie.
      root = REXML::Document.new(responsexml).root
      if root.attributes['outStatus'].nil?
        raise Puppet::Error, "Cannot obtain logout status from response"
      end
      Puppet.notice "Status of logout operation- " + root.attributes['outStatus']
    end

    def getcookie
=begin
      unless @cookie
        login
      else
        refresh
        if !@cookie
          login
        end
      end
      return @cookie
=end
      login
    end
  end
end
