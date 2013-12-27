# "This is base class for ciscoucs"

require 'rest-client'

begin
  require 'puppet_x/puppetlabs/transport'
rescue LoadError => error
  require 'pathname'
  ucs_module = Puppet::Module.find('ciscoucs', Puppet[:environment].to_s)
  require File.join ucs_module.path, 'lib/puppet_x/puppetlabs/transport'
end

begin
  require 'puppet_x/puppetlabs/transport/ciscoucs'
rescue LoadError => error
  require 'pathname'
  module_lib = Pathname.new(__FILE__).parent.parent.parent
  require File.join module_lib, 'puppet_x/puppetlabs/transport/ciscoucs'
end

class Puppet::Provider::Ciscoucs < Puppet::Provider
  def cookie
    @transport ||= PuppetX::Puppetlabs::Transport.retrieve(:resource_ref => resource[:transport], :catalog => resource.catalog, :provider => 'ciscoucs')
    value = @transport.cookie
    value.to_s
  end

  def url
    @transport.url
  end

  def disconnect
    @transport.close
  end

  def check_profile_exists(dn)
    request_xml = '<configResolveDn cookie="'+cookie+'"dn="' + dn + '" />'
    response_xml = post request_xml
    doc = REXML::Document.new(response_xml)
    return doc.elements["/configResolveDn/outConfig"].has_elements?
  end

  # Helper function for execution of Cisco UCS API commands
  def post(request_xml)
    begin
      result ||= RestClient.post url, request_xml, :content_type => 'text/xml'
    rescue RestClient::Exception => error
      #Puppet.debug "Failed REST #{m} to URL #{url}:\nXML Format:\n#{request_xml}"
      raise Puppet::Error, "\n#{error.exception}:\n#{error.response}"
    end
    #Puppet.debug "Cisco UCS Post: #{url} \n Request:\n#{request_xml} Response:\n#{result.inspect}"

  end
end
