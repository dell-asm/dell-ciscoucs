require 'rest_client'
require 'rexml/document'

module_lib = Pathname.new(__FILE__).parent.parent.parent
require File.join module_lib.to_s, '/util/ciscoucs/nested_hash'
require File.join module_lib.to_s, '/util/ciscoucs/Xmlformatter'

module PuppetX::Puppetlabs::Transport
  # "Base class for authenticate"
  class Authenticate
    @@cookie = ""
    def initialize(url, username, password)
      @url = url
      @username = username
      @password = password
    end

    def login
      formatter = PuppetX::Util::Ciscoucs::Xmlformatter.new("aaaLogin")
      parameters = PuppetX::Util::Ciscoucs::NestedHash.new
      parameters['/aaaLogin'][:inName] = @username
      parameters['/aaaLogin'][:inPassword] = @password
      requestxml = formatter.command_xml(parameters)
      if requestxml.to_s.strip.length == 0
        raise Puppet::Error, "Cannot create request xml for login operation"
      end
      begin
        responsexml = RestClient.post @url, requestxml, :content_type => 'text/xml'
      rescue RestClient::Exception => error
        raise Puppet::Error, "\n#{error.exception}:\n#{error.response}"
      end

      if responsexml.to_s.strip.length == 0
        raise Puppet::Error, "No response obtained from login operation"
      end
      # Create an XML doc and parse it to get the cookie.
      begin
        root = REXML::Document.new(responsexml).root
        if root.attributes['outCookie'].nil?
          raise Puppet::Error, "Cannot obtain cookie from response"
        end
        @firmwareversion= root.attributes['outVersion']
        @@cookie = root.attributes['outCookie']
        
      rescue Exception => msg
        raise Puppet::Error, "Following error occurred while parsing login response" +  msg.to_s
      end
    end

    def refresh
      formatter = PuppetX::Util::Ciscoucs::Xmlformatter.new("aaaRefresh")
      parameters = PuppetX::Util::Ciscoucs::NestedHash.new
      parameters['/aaaRefresh'][:inName] = @username
      parameters['/aaaRefresh'][:inPassword] = @password
      parameters['/aaaRefresh'][:inCookie] = @@cookie
      requestxml = formatter.command_xml(parameters)
      if requestxml.to_s.strip.length == 0
        raise Puppet::Error, "Cannot create request xml for refresh operation"
      end
      begin
        responsexml = RestClient.post @url, requestxml, :content_type => 'text/xml'
      rescue RestClient::Exception => error
        raise Puppet::Error, "\n#{error.exception}:\n#{error.response}"
      end

      if responsexml.to_s.strip.length == 0
        raise Puppet::Error, "No response obtained from refresh operation"
      end
      # Create an XML doc and parse it to get the cookie.
      begin
        root = REXML::Document.new(responsexml).root
        if root.attributes['outCookie'].nil?
          raise Puppet::Error, "Cannot obtain cookie from response"
        end
        @@cookie = root.attributes['outCookie']
      rescue Exception => msg
        raise Puppet::Error, "Following error occurred while parsing refresh response" +  msg.to_s
      end
    end

    def logout
      Puppet.debug("#{self.class} closing connection to:  #{@url}")
      formatter = PuppetX::Util::Ciscoucs::Xmlformatter.new("aaaLogout")
      parameters = PuppetX::Util::Ciscoucs::NestedHash.new
      parameters['/aaaLogout'][:inCookie] = @@cookie
      requestxml = formatter.command_xml(parameters)
      if requestxml.to_s.strip.length == 0
        raise Puppet::Error, "Cannot create request xml for logout operation"
      end
      begin
        responsexml = RestClient.post @url, requestxml, :content_type => 'text/xml'
      rescue RestClient::Exception => error
        raise Puppet::Error, "\n#{error.exception}:\n#{error.response}"
      end

      if responsexml.to_s.strip.length == 0
        raise Puppet::Error, "No response obtained from logout operation"
      end
      # Create an XML doc and parse it to get the cookie.
      begin
        root = REXML::Document.new(responsexml).root
        if root.attributes['outStatus'].nil?
          raise Puppet::Error, "Cannot obtain logout status from response"
        end
        Puppet.notice "Status of logout operation- " + root.attributes['outStatus']
      rescue Exception => msg
        raise Puppet::Error, "Following error occurred while parsing logout response" +  msg.to_s
      end
    end
    def getfirmwareversion
      @firmwareversion
    end
    def getcookie
      if !@@cookie || @@cookie.strip.length == 0
        login
      else
        refresh
        if !@@cookie || @@cookie.strip.length == 0
          login
        end
      end
      return @@cookie
      #      login
    end
  end
end
