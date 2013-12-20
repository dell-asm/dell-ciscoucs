require 'puppet_x/puppetlabs/transport/authenticate'


module PuppetX::Puppetlabs::Transport
  # "Base class for ciscoucs"
  class Ciscoucs
    attr_accessor :cookie, :url
    attr_reader :name, :user, :password, :host
    def initialize(option)
      @user     = option[:username]
      @password = option[:password]
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
  end
end
