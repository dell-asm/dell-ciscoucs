Puppet::Type.newtype(:create_vlan) do 
  @doc = "cisco ucs create vlan"
  
  
  Puppet.debug "testing ********"
  #apply_to_device  
  ensurable 
  
  newparam(:name) do
     desc "vlan id prefix.Valid characters are a-z, 1-9. Max length is 33"
     isnamevar
     validate do |value|
#       if value.strip.length > 63
#               raise ArgumentError, "The vlan prefix length is more than 33 characters." % value
#       else
       unless value =~ /\S+$/
         raise ArgumentError, "The %s is an invalid vlan prefix" % value
       end
     end
   end
   
   
  newparam(:id) do
    desc "vlan id to be created ."
    validate do |value|
      unless value =~ /\d+/
         raise ArgumentError, "The %s is an invalid vlan id." % value
     end
   end
  end

  
  newparam(:mcast_policy_name) do
      desc "vlan mcast policy name to be associated ."
    end
    
    
  newparam(:policy_owner) do
      desc "policy owner ."
      validate do |value|
        unless value =~ /\S+/
           raise ArgumentError, "The %s is an invalid policy owner." % value
       end
     end
    end
    
  newparam(:sharing) do
        desc "vlan id to be created ."
        validate do |value|
          unless value =~ /\S+/
             raise ArgumentError, "The %s is an invalid sharing value." % value
         end
       end
      end
      
      
  newparam(:status) do
    desc "The space reservation mode."
  end

end
