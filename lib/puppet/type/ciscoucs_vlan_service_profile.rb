Puppet::Type.newtype(:ciscoucs_vlan_service_profile) do
  @doc = 'Update VLAN in Service Profile Cisco UCS device.'
  ensurable
  newparam(:name) do
    desc "Name of Service Profile"
    validate do |value|
      if value && value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is not a valid name." % value
        end
      end
    end
  end

  newparam(:vlanname) do
    desc "Name of VLAN"
    validate do |value|
      if value && value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is not a valid name." % value
        end
      end
    end
  end

  newparam(:serviceprofileorg) do
    desc "Name of Service Profile organization"
    validate do |value|
      if value && value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is not a valid name." % value
        end
      end
    end
  end

  newparam(:vnic) do
    desc "Name of vNIC"
    validate do |value|
      if value && value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is not a valid name." % value
        end
      end
    end
  end


  newparam(:defaultnet) do
    desc "Set Native VLAN"
    newvalues(:yes, :no)
  end

end

