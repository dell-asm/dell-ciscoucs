Puppet::Type.newtype(:ciscoucs_serviceprofile) do
  @doc = 'Create service profile on cisco ucs device'
  ensurable do
    newvalue(:present) do
      provider.create
    end

    newvalue(:absent) do
      provider.destroy
    end

    defaultto(:present)
  end

  newparam(:name, :namevar => true) do
    desc "Name of service profile"
    validate do |value|
      if value.strip.length == 0
        raise ArgumentError, "Invalid service profile name."
      end
    end
  end

#  newproperty(:power_state) do
#    desc 'Power state of a service profile'
#    newvalues(:up, :down)
#    #      defaultto(:up)
#  end

end