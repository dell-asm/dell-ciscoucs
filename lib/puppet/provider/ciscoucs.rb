#require 'puppet_x/puppetlabs/transport'
#require 'puppet_x/puppetlabs/transport/ciscoucs'
begin
  require 'puppet_x/puppetlabs/transport'
rescue LoadError => e
  require 'pathname'
  ucs_module = Puppet::Module.find('ciscoucs', Puppet[:environment].to_s)
  require File.join ucs_module.path, 'lib/puppet_x/puppetlabs/transport'
end

begin
  require 'puppet_x/puppetlabs/transport/vsphere'
rescue LoadError => e
  require 'pathname'
  module_lib = Pathname.new(__FILE__).parent.parent.parent
  require File.join module_lib, 'puppet_x/puppetlabs/transport/ciscoucs'
end

class Puppet::Provider::CiscoUCS < Puppet::Provider
  def cookie
    @transport ||= PuppetX::Puppetlabs::Transport.retrieve(:resource_ref => resource[:transport], :catalog => resource.catalog, :provider => 'ciscoucs')
    @transport.cookie
  end

  # Helper function for execution of Cisco UCS API commands
  def post
    # begin
    #  result ||= RestClient.post @url, connectionxml, :content_type => 'text/xml'

    #rescue RestClient::Exception => e
    # Puppet.debug "Failed REST #{m} to URL #{url}:\n#{data}\nXML Format:\n#{Gyoku.xml data}"
    #raise Puppet::Error, "\n#{e.exception}:\n#{e.response}"
    #end
    #Puppet.debug "VShield REST API #{m} #{url} with #{data.inspect} result:\n#{result.inspect}"

  end
end
