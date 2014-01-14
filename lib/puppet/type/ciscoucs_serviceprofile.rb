Puppet::Type.newtype(:ciscoucs_serviceprofile) do
  @doc = 'This represents Create Service Profile on the Cisco UCS'
  ensurable

  newparam(:organization) do
    desc "This parameter describes name of the service profile organization. A valid format for service profile organization is org-root/[sub-organization]/[sub-organization]...."
    validate do |value|
      if value && value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is invalid." % value
        end
      end
    end
  end

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

  newparam(:profile_dn) do
    desc "This parameter describes service profile dn . A valid format for service profile dn is org-root/[sub-organization]/[sub-organization]..../ls-[profile name]"
    validate do |value|
      if value  &&  value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is invalid." % value
        end
      end
    end
  end

  newparam(:source_template) do
    desc "This parameter describes source template name from which the service profile is to be created. A valid format for source template name is org-root/[sub-organization]/[sub-organization]..../ls-[template name]"
    validate do |value|
      if value && value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is invalid." % value
        end
      end
    end
  end

  newparam(:number_of_profiles) do
    desc "This parameter describes number of profiles to be created"
    validate do |value|
      if value && value.strip.length != 0
        # value should be an integer
        unless value =~ /\A[0-9]+\Z/
          raise ArgumentError, "%s is invalid." % value
          if value.to_i > 255
                      raise ArgumentError, "%s is invalid." % value
          end
        end
      end
    end
  end

  newparam(:server_chassis_id) do
       desc "This parameter describes server chassis id from which the service profile is to be created"
       validate do |value|
         if value.strip.length != 0
           # unless value =~ /\A[a-zA-Z0-9\d_\.\:]+\Z/
           #  raise ArgumentError, "%s is invalid." % value
           # end
         end
       end
     end
     
   newparam(:server_slot) do
         desc "This parameter describes server slot on which the service profile is to be created"
         validate do |value|
           if value.strip.length != 0
             # unless value =~ /\A[a-zA-Z0-9\d_\.\:]+\Z/
             #  raise ArgumentError, "%s is invalid." % value
             # end
           end
         end
    end
  newproperty(:power_state) do
    desc 'This parameter describes power state of a service profile'
    newvalues(:up, :down)
    #defaultto(:up)
  end

  validate do
    if !self[:profile_dn] || self[:profile_dn].strip.length==0
      # if profile_dn is empty then both organization or profile name should exists.
      if (!self[:organization] || self[:organization].strip.length == 0) || (!self[:serviceprofile_name] || self[:serviceprofile_name].strip.length == 0)
        raise ArgumentError, "Either profile_dn or both organization and profile name is to be provided as an input."
      end
    end
  end

end
