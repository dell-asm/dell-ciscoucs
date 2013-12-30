Puppet::Type.newtype(:ciscoucs_update_boot_policy) do
  @doc = 'Update boot policy on service profile'

  ensurable

  newparam(:bootpolicyname, :namevar => true) do
    desc "Name of the boot policy"
    validate do |value|
      if (!value) || (value.strip.length == 0)
        raise ArgumentError, "Invalid boot policy name."
      else
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is not a valid name." % value
        end
      end
    end
  end

  newparam(:dn) do
    desc "DN of service profile"
    validate do |value|
      if (!value) || (value.strip.length == 0)
        raise ArgumentError, "Invalid DN."
      else
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is not a valid name." % value
        end
      end
    end
  end

  newparam(:organization) do
    desc "Organization name for policy"
    validate do |value|
      if (!value) || (value.strip.length == 0)
        raise ArgumentError, "Invalid organization name for policy."
      else
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is not a valid name." % value
        end
      end
    end
  end
end

