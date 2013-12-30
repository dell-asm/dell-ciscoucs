Puppet::Type.newtype(:ciscoucs_serviceprofile_association) do
  @doc = 'Associate or disassociate service profile on cisco ucs device'

  ensurable

  newparam(:service_profile_name, :namevar => true) do
    desc "Name of service profile"
    validate do |value|
      if value && value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is not a valid name." % value
        end
      end
    end
  end

  newparam(:organization_name) do
    desc "Name of organization"
    validate do |value|
      if value && value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is not a valid name." % value
        end
      end
    end
  end

  newparam(:profile_dn) do
    desc "Server profile DN"
    validate do |value|
      if value  &&  value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is not a valid value." % value
        end
      end
    end
  end

  newparam(:server_chassis_id) do
    desc "Server chassis id to which profile has to be associated"
    validate do |value|
      if value  &&  value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is not a valid value." % value
        end
      end
    end
  end

  newparam(:server_slot_id) do
    desc "Server slot id to which profile has to be associated"
    validate do |value|
      if value  &&  value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is not a valid value." % value
        end
      end
    end
  end

  newparam(:server_dn) do
    desc "Server DN"
    validate do |value|
      if value  &&  value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is not a valid value." % value
        end
      end
    end
  end

  validate do
    if !self[:profile_dn] || self[:profile_dn].strip.length==0
      # if dn is empty then both org or profile name should exists.
      if (!self[:organization_name] || self[:organization_name].strip.length == 0) ||
      (!self[:service_profile_name] || self[:service_profile_name].strip.length == 0)
        raise ArgumentError, "Either dn or both organization and profile name should be given as input."
      end
    end
    if !self[:server_dn] || self[:server_dn].strip.length==0
      # if dn is empty then both org or profile name should exists.
      if (!self[:server_slot_id] || self[:server_slot_id].strip.length == 0) ||
      (!self[:server_chassis_id] || self[:server_chassis_id].strip.length == 0)
        raise ArgumentError, "Either dn or both slot id and chassis id should be given as input."
      end
    end

  end

end
