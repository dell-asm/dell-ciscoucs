require 'puppet/util/network_device'
require 'puppet/util/network_device/ciscoucs/facts'
require 'uri'
require 'cgi'
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
      @url = URI.parse(url)
      @query = Hash.new([])
      @query = CGI.parse(@url.query) if @url.query

      @user = @url.user
      @password = URI.decode(asm_decrypt(@url.password))
      @host = @url.host

      override_using_credential_id
    end

    def override_using_credential_id
      if id = @query['credential_id'].first
        require 'asm/cipher'
        cred = ASM::Cipher.decrypt_credential(id)
        @user = cred.username
        @password = cred.password
      end
    end

    def facts
      @facts ||= Puppet::Util::NetworkDevice::Ciscoucs::Facts.new(@transport)
      facts = @facts.retrieve

      facts
    end
  end
end
