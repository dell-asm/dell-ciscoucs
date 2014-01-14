Puppet::Type.newtype(:transport_ciscoucs) do
  @doc = "Manage transport connectivity information on cisco ucs device"
  newparam(:name, :namevar => true) do
    desc "Name of the network transport."
  end

  newparam(:username) do
    desc "User name for ciscoucs device"
    validate do |value|
      if value && value.strip.length == 0
        raise ArgumentError, "Username can not be blank"
      end
    end
  end

  newparam(:password) do
    desc "Password for ciscoucs device"
    validate do |value|
      if value && value.strip.length == 0
        raise ArgumentError, "Password can not be blank"
      end
    end
  end
  newparam(:server) do
    desc "Server ip for ciscoucs device"
    validate do |value|
      if value && value.strip.length == 0
        raise ArgumentError, "IP Address can not be blank"
      end
      unless /\A(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})\Z/ =~ value
        raise ArgumentError, "Invalid IP Address"
      end
    end
  end
end

unless Puppet::Type.metaparams.include? :transport
  Puppet::Type.newmetaparam(:transport) do
    desc "Provide a new meta parameter for all resources called transport."
  end
end
