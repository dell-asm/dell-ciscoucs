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
    desc "name of server profile"
  end

  #newproperty(:power_state) do
  # desc 'whether or not power should be enabled'
  #newvalues(:on, :off)
  #    defaultto(:on)
  # end

end

# property - on/off
# operation - create/destroy
# service profile_template - operation
