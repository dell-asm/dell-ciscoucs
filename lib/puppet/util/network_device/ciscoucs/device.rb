require 'puppet/util/network_device'
require 'puppet/util/network_device/ciscoucs/facts'
require 'uri'
require 'net/https'

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

module Puppet::Util::NetworkDevice::Ciscoucs
  class Device

    attr_accessor :url, :transport
    def initialize(url, option = {})
      Puppet.debug("Device login started")
      parse(url)
      res_hash = Hash.new
      res_hash[:username] = @user
      res_hash[:password] = @password
      res_hash[:server] = @host
      @transport = PuppetX::Puppetlabs::Transport::Ciscoucs.new(res_hash)
      @transport.connect

    end

    def parse(url)
      # todo: all password parsing related work 
      res = url.split("//")
      temp = res[1]
      output = temp.split(":")
      username = output[0]
      text = output[1]
      pos = text.rindex('@')
      length = text.length()
      password = text[0,pos]
      @host = text[pos+1, length]
      @user = URI.decode(username)
      @password = URI.decode(password)
    end

    def facts
      @facts ||= Puppet::Util::NetworkDevice::Ciscoucs::Facts.new(@transport)
      facts = @facts.retrieve

      facts
    end
  end
end
