Puppet::Type.newtype(:ciscoucs_update_boot_policy) do
  @doc = 'Clone service profile on cisco ucs device'
  ensurable do
    newvalue(:present) do 
      provider.create
    end

    newvalue(:absent) do
	  provider.destroy
    end

    defaultto(:present)
  end

  newparam(:key) do
    desc "dn of service profile"
    validate do |value|
	   if value.strip.length != 0
	       unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
               raise ArgumentError, "%s is not a valid name." % value
          end
	  end
	end
  end

 newparam(:status) do
    desc "status, either create or update"
  end

  newparam(:bootpolicyname, :namevar => true) do
    desc "boot policy name"
    validate do |value|
	   if value.strip.length != 0
	       unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
               raise ArgumentError, "%s is not a valid name." % value
          end
	  end
	end
  end

end

