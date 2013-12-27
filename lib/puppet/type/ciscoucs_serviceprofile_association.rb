Puppet::Type.newtype(:ciscoucs_serviceprofile_association) do
  @doc = 'Associate service profile Associate on cisco ucs device'
  
  @organization_name = '';
  @service_profile_name = '';
  @server_chesis_id = '';
  @server_slot = '';

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
    puts "Name of associate server profile";
  end

  newparam(:organization_name) do
      desc "Organization Name of service profile"
      validate do |value|
        if value.strip.length != 0
      #    unless value =~ /\A[a-zA-Z0-9\d_\.\:]+\Z/
       #     raise ArgumentError, "%s is not a valid value." % value
        #  end
        end
      end
    end
  
    newparam(:service_profile_name) do
      desc "Name of service profile"
      validate do |value|
        if value.strip.length != 0
         # unless value =~ /\A[a-zA-Z0-9\d_\.\:]+\Z/
          #  raise ArgumentError, "%s is not a valid value." % value
         # end
        end
      end
    end
  
    newparam(:profile_dn) do
      desc "Name of service profile"
      validate do |value|
        if value.strip.length == 0
          # if dn is empty then both org or profile name should exists.
          if resource[:organization_name].strip.length == 0 || resource[:service_profile_name].strip.length == 0
            raise ArgumentError, "Either dn or both org and profile name should be given in input."
          end
        else
          #unless value =~ /\A[a-zA-Z0-9\d_\.\:]+\Z/
           # raise ArgumentError, "%s is not a valid value." % value
          #end
        end
      end
    end
  
  
  newparam(:server_chesis_id) do
        desc "Organization Name of service profile"
        validate do |value|
          if value.strip.length != 0
        #    unless value =~ /\A[a-zA-Z0-9\d_\.\:]+\Z/
         #     raise ArgumentError, "%s is not a valid value." % value
          #  end
          end
        end
      end
    
      newparam(:server_slot) do
        desc "Name of service profile"
        validate do |value|
          if value.strip.length != 0
           # unless value =~ /\A[a-zA-Z0-9\d_\.\:]+\Z/
            #  raise ArgumentError, "%s is not a valid value." % value
           # end
          end
        end
      end
    
      newparam(:server_dn) do
        desc "Name of service profile"
        validate do |value|
          if value.strip.length == 0
            # if dn is empty then both org or profile name should exists.
            if resource[:server_chesis_id].strip.length == 0 || resource[:server_slot].strip.length == 0
              raise ArgumentError, "Either dn or both chesis id and server slot should be given in input."
            end
          else
            #unless value =~ /\A[a-zA-Z0-9\d_\.\:]+\Z/
             # raise ArgumentError, "%s is not a valid value." % value
            #end
          end
        end
      end
  
end
