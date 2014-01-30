require 'puppet/util/network_device'
require 'puppet/util/network_device/ciscoucs/facts'
require 'uri'
require 'net/https'
require '/etc/puppetlabs/puppet/modules/asm_lib/lib/security/encode'


module_lib = Pathname.new(__FILE__).parent.parent.parent.parent.parent
require File.join module_lib.to_s, '/puppet_x/puppetlabs/transportciscoucs'
require File.join module_lib.to_s, '/puppet_x/puppetlabs/transportciscoucs/ciscoucs'

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
      @transport = PuppetX::Puppetlabs::Transportciscoucs::Ciscoucs.new(res_hash)
      @transport.connect
    end

    def parse(url)
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
	  @password = URI.decode(asm_decrypt(password))
    end

    def facts
      @facts ||= Puppet::Util::NetworkDevice::Ciscoucs::Facts.new(@transport)
      facts = @facts.retrieve

      facts
    end
  end
end
