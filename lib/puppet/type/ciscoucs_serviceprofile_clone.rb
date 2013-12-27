Puppet::Type.newtype(:ciscoucs_serviceprofile_clone) do
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

  newparam(:sourceserviceprofilename) do
    desc "name of source server profile name"
  end

 newparam(:sourceorganization) do
    desc "name of source organization"
  end

  newparam(:sourceprofiledn, :namevar => true) do
    desc "name of server profile"
     validate do |value|
	   if value.strip.length != 0
	       unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
               raise ArgumentError, "%s is not a valid name." % value
          end
	  end
	end
  end

 newparam(:targetserviceprofilename) do
    desc "name of target server profile name"
  end

 newparam(:targetorganization) do
    desc "name of target organization"
  end

  newparam(:targetprofiledn) do
    desc "name of server profile clone"	
     validate do |value|
	   if value.strip.length != 0
	       unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
               raise ArgumentError, "%s is not a valid name." % value
          end
	  end
	end
  end

end

