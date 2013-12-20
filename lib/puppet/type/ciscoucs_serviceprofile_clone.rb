Puppet::Type.newtype(:ciscoucs_serviceprofile_clone) do
  @doc = 'Clone service profile on cisco ucs device'
  ensurable do
    newvalue(:present) do 
	  puts "newvalue(:present "
      provider.create
    end

    newvalue(:absent) do
      puts "newvalue(:absent "
	  provider.destroy
    end

    defaultto(:present)
  end

  newparam(:clonename, :namevar => true) do
    desc "name of server profile clone"
	validate do |value|
      if value.strip.length == 0
        raise ArgumentError, "Invalid clone server name."
      end
    end
  end

  newparam(:source) do
    desc "name of server dn"
	validate do |value|
      if value.strip.length == 0
        raise ArgumentError, "Invalid dn name."
      end
    end
  end

 newparam(:target) do
    desc "name of server profile"
	validate do |value|
      if value.strip.length == 0
        raise ArgumentError, "Invalid origin server name."
      end
    end
  end

end

