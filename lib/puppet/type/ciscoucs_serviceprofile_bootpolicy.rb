Puppet::Type.newtype(:ciscoucs_serviceprofile_bootpolicy) do
  @doc = 'This represents updation of service profile boot policy on cisco ucs'
  
  ensurable do
     newvalue(:modify) do
       provider.create
     end 
     defaultto(:modify)
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

  newparam(:serviceprofile_organization) do
    desc "This parameter describes name of the service profile organization. A valid format is org-root/[sub-organization]/[sub-organization]...."
    validate do |value|
      if value && value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is invalid." % value
        end
      end
    end
  end

  newparam(:serviceprofile_dn) do
    desc "This parameter describes source service profile dn. A valid format is org-root/[sub-organization]/[sub-organization]..../ls-[profile name]"
    validate do |value|
      if value  &&  value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is invalid." % value
        end
      end
    end
  end

  newparam(:bootpolicy_name) do
    desc "This parameter describes name of the boot policy"
    validate do |value|
      if value && value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is invalid." % value
        end
      end
    end
  end

  newparam(:bootpolicy_organization) do
    desc "This parameter describes name of boot policy organization. A valid format is org-root/[sub-organization]/[sub-organization]...."
    validate do |value|
      if value && value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is invalid." % value
        end
      end
    end
  end

  newparam(:bootpolicy_dn) do
    desc "This parameter describes Boot policy dn. A valid format is org-root/boot-policy-[policy name]"
    validate do |value|
      if value  &&  value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is invalid." % value
        end
      end
    end
  end

  validate do
    if !self[:bootpolicy_dn] || self[:bootpolicy_dn].strip.length==0
      # if bootpolicydn is empty then both bootpolicyorganization and bootpolicyname should exists.
      if (!self[:bootpolicy_organization] || self[:bootpolicy_organization].strip.length == 0) || (!self[:bootpolicy_name] || self[:bootpolicy_name].strip.length == 0)
        raise ArgumentError, "Provide either dn or both boot policy organization and policy name as input."
      end
    end
    if !self[:serviceprofile_dn] || self[:serviceprofile_dn].strip.length==0
          # if serviceprofiledn is empty then both serviceprofileorganization and serviceprofilename should exists.
          if (!self[:serviceprofile_organization] || self[:serviceprofile_organization].strip.length == 0) || (!self[:serviceprofile_name] || self[:serviceprofile_name].strip.length == 0)
            raise ArgumentError, "Provide either dn or both service profile organization and service profile name as input."
          end
        end
        
  end

end

