Puppet::Type.newtype(:ciscoucs_serviceprofile_association) do
  @doc = 'Associate or disassociate service profile on cisco ucs device'

  ensurable

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

  newparam(:organization) do
    desc "Name of the organization. Valid format is org-root/[sub-organization]/[sub-organization]...."
    validate do |value|
      if value && value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is invalid." % value
        end
      end
    end
  end

  newparam(:profile_dn) do
    desc "Server profile dn. Valid format is org-root/[sub-organization]/[sub-organization]..../ls-[profile name]"
    validate do |value|
      if value  &&  value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is invalid." % value
        end
      end
    end
  end

  newparam(:server_chassis_id) do
    desc "Server chassis id to which profile has to be associated"
    validate do |value|
      if value  &&  value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is invalid." % value
        end
      end
    end
  end

  newparam(:server_slot_id) do
    desc "Server slot id to which profile has to be associated"
    validate do |value|
      if value  &&  value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is invalid." % value
        end
      end
    end
  end

  newparam(:server_dn) do
    desc "Server dn"
    validate do |value|
      if value  &&  value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is invalid." % value
        end
      end
    end
  end

  validate do
    if !self[:profile_dn] || self[:profile_dn].strip.length==0
      # if dn is empty then both org or profile name should exists.
      if (!self[:organization] || self[:organization].strip.length == 0) ||
      (!self[:serviceprofile_name] || self[:serviceprofile_name].strip.length == 0)
        raise ArgumentError, "Either dn or both profile organization and profile name should be given as input."
      end
    end
    if !self[:server_dn] || self[:server_dn].strip.length==0
      # if dn is empty then both org or profile name should exists.
      if (!self[:server_slot_id] || self[:server_slot_id].strip.length == 0) ||
      (!self[:server_chassis_id] || self[:server_chassis_id].strip.length == 0)
        raise ArgumentError, "Either dn or both server slot id and server chassis id should be given as input."
      end
    end

  end

end
