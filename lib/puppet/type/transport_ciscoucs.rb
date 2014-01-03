Puppet::Type.newtype(:transport_ciscoucs) do
  @doc = "Manage transport connectivity information on cisco ucs device"

  newparam(:name, :namevar => true) do
    desc "Name of the network transport."
  end

  newparam(:username) do 
	desc "User name for ciscoucs device"
  end

  newparam(:password) do
    desc "Password for ciscoucs device"
  end

  newparam(:server) do
    desc "Server ip for ciscoucs device"
	defaultto('localhost')
  end
end

unless Puppet::Type.metaparams.include? :transport
  Puppet::Type.newmetaparam(:transport) do
    desc "Provide a new meta parameter for all resources called transport."
  end
end
