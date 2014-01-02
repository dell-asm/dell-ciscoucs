Puppet::Type.newtype(:ciscoucs_vlan) do
  @doc = "cisco ucs create vlan"
  ensurable

  newparam(:name) do
    desc "vlan id prefix.Valid characters are a-z, 1-9. Max length is 33"
    isnamevar
    validate do |value|
      if value.strip.length > 33
        raise ArgumentError, "The vlan prefix length is more than 33 characters." % value
      else
        unless value =~ /\S+$/
          raise ArgumentError, "The %s is an invalid vlan prefix" % value
        end
      end
    end
  end

  newparam(:id) do
    desc "vlan id to be created. Must be numeric"
    validate do |value|
      unless value =~ /\d+/
        raise ArgumentError, "The %s is an invalid vlan id." % value
      end
      if (value.to_i > 3967 || value.to_i <= 0)
        raise ArgumentError, "VLAN Id cannot greater than 3967. VLAN id given is "% value
      end
    end
  end

  newparam(:fabric_id) do
    desc "fabric id at which vlan would be provisioned. "
    validate do |value|
      if value.strip.length > 0
        unless value =~ /[a|b|A|B]/
          raise ArgumentError, "The %s is an invalid fabric id." % value
        end
      end
    end
  end

  newparam(:mcast_policy_name) do
    desc "vlan mcast policy name to be associated ."
    validate do |value|
      if value.strip.length > 0
        if value.strip.length > 16
          raise ArgumentError, "The vlan mcast policy name length is more than 33 characters." % value
        else
          unless value =~ /\S+$/
            raise ArgumentError, "The %s is an invalid vlan mcast policy name" % value
          end
        end
      end
    end
  end

  newparam(:sharing) do
    desc "The vlan id sharing status . Valid options are: none, primary."
    newvalues(:none, :primary)
    defaultto(:none)
  end

  newparam(:status) do
    desc "The vlan id operation status . Valid options are: created, deleted."
    newvalues(:created, :deleted)
  end
end

