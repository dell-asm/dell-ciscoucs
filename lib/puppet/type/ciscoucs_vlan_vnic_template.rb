Puppet::Type.newtype(:ciscoucs_vlan_vnic_template) do
  @doc = 'Update VLAN in vNIC template Cisco UCS device.'
  ensurable
  newparam(:name) do
    desc "Name of vNIC Template"
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

  newparam(:vnictemplateorg) do
    desc "Name of vNIC Template organization"
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

