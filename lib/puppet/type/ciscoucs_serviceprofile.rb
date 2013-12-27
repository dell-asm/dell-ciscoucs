Puppet::Type.newtype(:ciscoucs_serviceprofile) do
  @doc = 'Create service profile on cisco ucs device'
  ensurable

  newparam(:org) do
    desc "Organization Name of service profile"
    validate do |value|
      if value.strip.length != 0
        #    unless value =~ /\A[a-zA-Z0-9\d_\.\:]+\Z/
        #     raise ArgumentError, "%s is not a valid value." % value
        #  end
      end
    end
  end

  newparam(:name, :namevar => true) do
    desc "Name of service profile"
    validate do |value|
      if value.strip.length != 0
        # unless value =~ /\A[a-zA-Z0-9\d_\.\:]+\Z/
        #  raise ArgumentError, "%s is not a valid value." % value
        # end
      end
    end
  end

  newparam(:dn) do
    desc "Name of service profile"
    validate do |value|
      if value.strip.length == 0
        # if dn is empty then both org or profile name should exists.
        if resource[:org].strip.length == 0 || resource[:name].strip.length == 0
          raise ArgumentError, "Either dn or both org and profile name should be given in input."
        end
      else
        #unless value =~ /\A[a-zA-Z0-9\d_\.\:]+\Z/
        # raise ArgumentError, "%s is not a valid value." % value
        #end
      end
    end
  end

  newparam(:source_template) do
    desc "Source template name from which service profile needs to be created"
    validate do |value|
      if value.strip.length != 0
        # unless value =~ /\A[a-zA-Z0-9\d_\.\:]+\Z/
        #  raise ArgumentError, "%s is not a valid value." % value
        # end
      end
    end
  end

  newparam(:number_of_profiles) do
    desc "Number of profiles to be created"
    validate do |value|
      # value should be an integer
      unless value =~ /\A[0-9]+\Z/
        raise ArgumentError, "%s is not a valid name." % value
      end
    end
  end

  newproperty(:power_state) do
    desc 'Power state of a service profile'
    newvalues(:up, :down)
    defaultto(:up)
  end
end

=begin
"Template Name - Name of the Service Profile Template
Organization Name - Organization name (e.g root)
Profile name prefix - Profile Name Prefix
Server Profile Template DN (Optional) - DN of the service profile (e.g. /org-root/ls-Template1)
Count of Profile - Number of profiles to be initiated.
UCS Connection Information - IP Address/Hostname, Username, Password"

"Server Org Name - Server Organization name
Server Chassis Id - Server Chassis ID
Server Slot - Server Slot
Server DN (optional) - Server DN
UCS Connection Information - IP Address/Hostname, Username, Password"

=end
