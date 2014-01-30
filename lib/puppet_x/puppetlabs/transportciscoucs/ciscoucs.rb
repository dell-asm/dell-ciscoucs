require 'puppet_x/puppetlabs/transportciscoucs/authenticate'
require '/etc/puppetlabs/puppet/modules/asm_lib/lib/security/encode'


module PuppetX::Puppetlabs::Transportciscoucs
  # "Base class for ciscoucs"
  class Ciscoucs
    attr_accessor :cookie, :url
    attr_reader :name, :user, :password, :host
    def initialize(option)
      @user     = option[:username]
	  @password = URI.decode(asm_decrypt(option[:password]))
      @host     = option[:server]
      @url    = "https://#{@host}/nuova"
      @authenticate =  Authenticate.new(@url, @user, @password)
      Puppet.debug("#{self.class} initializing connection to: #{@host}")
    end

    def connect
      @cookie = @authenticate.getcookie
    end

    def close
      @authenticate.logout
    end
    
    def firmwareversion
      @authenticate.getfirmwareversion
    end
  end
end
