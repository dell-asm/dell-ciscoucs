require 'puppet/util/network_device/ciscoucs/device'

class Puppet::Provider::CiscoUCS < Puppet::Provider

  attr_accessor :device

  def self.transport
    #if Facter.value(:url) then
    #  Puppet.debug "Puppet::Util::NetworkDevice::CiscoUCS: connecting via facter url."
     # @device ||= Puppet::Util::NetworkDevice::CiscoUCS::Device.new(Facter.value(:url))
    #else
      @device ||= Puppet::Util::NetworkDevice.current
      raise Puppet::Error, "Puppet::Util::NetworkDevice::CiscoUCS: device not initialized #{caller.join("\n")}" unless @device
    #end

    @tranport = @device.transport
  end

  def transport
    # this calls the class instance of self.transport instead of the object instance which causes an infinite loop.
    self.class.transport
  end

  
end
