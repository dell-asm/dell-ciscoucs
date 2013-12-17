require 'puppet_x/puppetlabs/authenticate'

module PuppetX::Puppetlabs::Transport
  class CiscoUCS
    attr_accessor :transport

    def initialize(option)
      @user     = option[:username]
      @password = option[:password]
      @host     = option[:server]
      @url    = "https://#{@host}/nuova"
      @authenticate = Authenticate.new(@url, @user, @password)
      Puppet.debug("#{self.class} initializing connection to: #{@host}")
    end

    def connect
      @authenticate.getCookie
    end

    def close
      @authenticate.logout
    end
  end
end
