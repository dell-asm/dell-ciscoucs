Puppet::Type.newtype(:ciscoucs_serviceprofile) do
  @doc = 'Create Service Profile on cisco ucs device'
  ensurable

  newparam(:organization) do
    desc "Name of the service profile Organization"
    validate do |value|
      if value && value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is invalid." % value
        end
      end
    end
  end

  newparam(:serviceprofile_name, :namevar => true) do
    desc "Name of the service profile"
    validate do |value|
      if value && value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is invalid." % value
        end
      end
    end
  end

  newparam(:profile_dn) do
    desc "Service profile dn"
    validate do |value|
      if value  &&  value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is invalid." % value
        end
      end
    end
  end

  newparam(:source_template) do
    desc "Source template name from which service profile will be created"
    validate do |value|
      if value && value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is invalid." % value
        end
      end
    end
  end

  newparam(:number_of_profiles) do
    desc "Number of profiles to be created"
    validate do |value|
      if value && value.strip.length != 0
        # value should be an integer
        unless value =~ /\A[0-9]+\Z/
          raise ArgumentError, "%s is invalid." % value
        end
      end
    end
  end

  newparam(:server_chassis_id) do
       desc "Server Chassis Id from which service profile will be created"
       validate do |value|
         if value.strip.length != 0
           # unless value =~ /\A[a-zA-Z0-9\d_\.\:]+\Z/
           #  raise ArgumentError, "%s is invalid." % value
           # end
         end
       end
     end
     
   newparam(:server_slot) do
         desc "Server Slot on which service profile needs to be created"
         validate do |value|
           if value.strip.length != 0
             # unless value =~ /\A[a-zA-Z0-9\d_\.\:]+\Z/
             #  raise ArgumentError, "%s is invalid." % value
             # end
           end
         end
    end
  newproperty(:power_state) do
    desc 'Power state of a service profile'
    newvalues(:up, :down)
    #defaultto(:up)
  end

  validate do
    if !self[:profile_dn] || self[:profile_dn].strip.length==0
      # if profile_dn is empty then both organization or profile name should exists.
      if (!self[:organization] || self[:organization].strip.length == 0) || (!self[:serviceprofile_name] || self[:serviceprofile_name].strip.length == 0)
        raise ArgumentError, "Either profile_dn or both organization and profile name should be given in input."
      end
    end
  end

end
