Puppet::Type.newtype(:ciscoucs_serviceprofile_boot_order) do
  @doc = 'This represents the updation of Boot order in the Boot policy'

  ensurable

  newparam(:bootpolicy_name, :namevar => true ) do
    desc "This parameter describes name of the Boot policy"
    validate do |value|
      if value && value.strip.length != 0        
       verifyinitial = value.to_s[0,1]  
       unless verifyinitial =~ /^[a-zA-Z]$/               
           raise ArgumentError, "%s is invalid." % value
       end
       unless value =~ /^[a-zA-Z0-9_.:-]{2,32}$/               
           raise ArgumentError, "%s is invalid." % value
       end          
     end
    end
  end

  newparam(:bootpolicy_dn) do
    desc "This parameter describes Boot policy dn. A valid format for the Boot policy dn is org-root/boot-policy-[policy name]"
    validate do |value|
      if value && value.strip.length != 0        
       verifyinitial = value.to_s[0,1]  
       unless verifyinitial =~ /^[a-zA-Z]$/               
           raise ArgumentError, "%s is invalid." % value
       end
       unless value =~ /^[a-zA-Z0-9_.:-]{2,32}$/               
           raise ArgumentError, "%s is invalid." % value
       end          
     end
    end
  end

  newparam(:organization) do
    desc "This parameter describes name of the Boot policy organization. A valid format for the Boot policy organization is org-root/[sub-organization]/[sub-organization]...."
    validate do |value|
      if value && value.strip.length != 0        
         verifyinitial = value.to_s[0,1]  
         unless verifyinitial =~ /^[a-zA-Z]$/               
             raise ArgumentError, "%s is invalid." % value
         end
         unless value =~ /^[a-zA-Z0-9_.:-]{2,32}$/               
             raise ArgumentError, "%s is invalid." % value
         end          
       end
    end
  end

  newparam(:lan_order) do
    desc "This parameter describes the New LAN Boot order, that must be an integer with a minimum value 1 and a maximum value 5"
    validate do |value|
      if value && value.strip.length != 0
        # value should be an integer from 1 to 5
        unless value =~ /\A[1-5]\Z/
          raise ArgumentError, "Allowed values for lan order is from 1 to 5"
        end
      else
        raise ArgumentError, "An empty or no value has been provided for the lanorder parameter."
      end
    end
  end 

  validate do
    if !self[:bootpolicy_dn] || self[:bootpolicy_dn].strip.length==0
      # if dn is empty then both org or profile name should exists.
      if (!self[:organization] || self[:organization].strip.length == 0) || (!self[:bootpolicy_name] || self[:bootpolicy_name].strip.length == 0)
        raise ArgumentError, "Either a dn value or both the organization and policy name is to be provided as input."
      end
    end
  end


end

