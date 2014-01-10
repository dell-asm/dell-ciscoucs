Puppet::Type.newtype(:ciscoucs_serviceprofile_association) do
  @doc = 'This represents association or disassociation service profile on cisco ucs'

  ensurable

  newparam(:serviceprofile_name, :namevar => true) do
    desc "This parameter describes name of the service profile"
    validate do |value|
      if value && value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is invalid." % value
        end
      end
    end
  end

  newparam(:organization) do
    desc "This parameter describes name of the organization. A Valid format is org-root/[sub-organization]/[sub-organization]...."
    validate do |value|
      if value && value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is invalid." % value
        end
      end
    end
  end

  newparam(:profile_dn) do
    desc "This parameter describes Server profile dn. A Valid format is org-root/[sub-organization]/[sub-organization]..../ls-[profile name]"
    validate do |value|
      if value  &&  value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is invalid." % value
        end
      end
    end
  end

  newparam(:server_chassis_id) do
    desc "This parameter describes the Server chassis id with which the profile is to be associated"
    validate do |value|
      if value  &&  value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is invalid." % value
        end
      end
    end
  end

  newparam(:server_slot_id) do
    desc "This parameter describes Server slot id with which the profile is to be associated"
    validate do |value|
      if value  &&  value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is invalid." % value
        end
      end
    end
  end

  newparam(:server_dn) do
    desc "This parameter describes Server dn"
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
        raise ArgumentError, "Provide either the dn or both the profile organization and profile name as input."
      end
    end
    if !self[:server_dn] || self[:server_dn].strip.length==0
      # if dn is empty then both org or profile name should exists.
      if (!self[:server_slot_id] || self[:server_slot_id].strip.length == 0) ||
      (!self[:server_chassis_id] || self[:server_chassis_id].strip.length == 0)
        raise ArgumentError, "Provide either dn or both server slot id and server chassis id as input."
      end
    end

  end

end
