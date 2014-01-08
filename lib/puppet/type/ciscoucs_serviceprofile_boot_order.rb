Puppet::Type.newtype(:ciscoucs_serviceprofile_boot_order) do
  @doc = 'Update booting order in boot policy'

  ensurable

  newparam(:bootpolicy_name, :namevar => true ) do
    desc "Name of the boot policy"
    validate do |value|
      if value && value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is invalid." % value
        end
      end
    end
  end

  newparam(:bootpolicy_dn) do
    desc "Boot policy DN .Valid format is org-root/boot-policy-[policy name]"
    validate do |value|
      if value  &&  value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is invalid." % value
        end
      end
    end
  end

  newparam(:organization) do
    desc "Name of the boot policy organization. Valid format is org-root/[sub-organization]/[sub-organization]...."
    validate do |value|
      if value && value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is invalid." % value
        end
      end
    end
  end

  newparam(:lan_order) do
    desc "New LAN order which should be integer from 1 to 5"
    validate do |value|
      if value && value.strip.length != 0
        # value should be an integer
        unless value =~ /\A[1-5]\Z/
          raise ArgumentError, "Allowed values for lan order is from 1 to 5"
        end
      else
        raise ArgumentError, "Empty or no value given for lanorder parameter."
      end
    end
  end
  

  validate do
    if !self[:bootpolicy_dn] || self[:bootpolicy_dn].strip.length==0
      # if dn is empty then both org or profile name should exists.
      if (!self[:organization] || self[:organization].strip.length == 0) || (!self[:bootpolicy_name] || self[:bootpolicy_name].strip.length == 0)
        raise ArgumentError, "Either dn or both organization and policy name should be given in input."
      end
    end
  end


end

