Puppet::Type.newtype(:ciscoucs_serviceprofile_clone) do
  @doc = 'Clone service profile on cisco ucs device'
  ensurable

  newparam(:sourceserviceprofilename, :namevar => true) do
    desc "name of source server profile name"
    validate do |value|
      if value && value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is not a valid name." % value
        end
      end
    end
  end

  newparam(:sourceorganization) do
    desc "name of source organization"
    validate do |value|
      if value && value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is not a valid name." % value
        end
      end
    end
  end

  newparam(:sourceprofiledn) do
    desc "name of server profile"
    validate do |value|
      if value  &&  value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is not a valid value." % value
        end
      end
    end
  end

  newparam(:targetserviceprofilename) do
    desc "name of target server profile name"
    validate do |value|
      if value && value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is not a valid name." % value
        end
      end
    end
  end

  newparam(:targetorganization) do
    desc "name of target organization"
    validate do |value|
      if value && value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is not a valid name." % value
        end
      end
    end
  end

  newparam(:targetprofiledn) do
    desc "name of server profile clone"
    validate do |value|
      if value  &&  value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is not a valid value." % value
        end
      end
    end
  end

  validate do
    if !self[:targetprofiledn] || self[:targetprofiledn].strip.length==0
      # if dn is empty then both org or profile name should exists.
      if (!self[:targetorganization] || self[:targetorganization].strip.length == 0) || (!self[:targetserviceprofilename] || self[:targetserviceprofilename].strip.length == 0)
        raise ArgumentError, "Either dn or both organization and profile name should be given in target."
      end
    end
    if !self[:sourceprofiledn] || self[:sourceprofiledn].strip.length==0
          # if dn is empty then both org or profile name should exists.
          if (!self[:sourceorganization] || self[:sourceorganization].strip.length == 0) || (!self[:sourceserviceprofilename] || self[:sourceserviceprofilename].strip.length == 0)
            raise ArgumentError, "Either dn or both organization and profile name should be given in source."
          end
        end
        
  end

end

