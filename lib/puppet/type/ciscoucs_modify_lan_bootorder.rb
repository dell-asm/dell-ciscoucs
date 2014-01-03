Puppet::Type.newtype(:ciscoucs_modify_lan_bootorder) do
  @doc = 'Update booting order in boot policy'

  ensurable

  newparam(:bootpolicyname, :namevar => true ) do
    desc "Name of the boot policy"
    validate do |value|
      if value && value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is invalid." % value
        end
      end
    end
  end

  newparam(:dn) do
    desc "Boot policy DN"
    validate do |value|
      if value  &&  value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is invalid." % value
        end
      end
    end
  end

  newparam(:organization) do
    desc "Name of the boot policy organization"
    validate do |value|
      if value && value.strip.length != 0
        unless value =~ /\A[a-zA-Z0-9\d_\.\:\-\/\s]{1,31}+\Z/
          raise ArgumentError, "%s is invalid." % value
        end
      end
    end
  end

  newparam(:lanorder) do
    desc "New LAN order"
    validate do |value|
      if value && value.strip.length != 0
        # value should be an integer
#        unless value =~ /\A[0-9]+\Z/
 #         raise ArgumentError, "%s is invalid." % value
  #      end
      end
    end
  end
  
=begin

  validate do
    if !self[:dn] || self[:dn].strip.length==0
      # if dn is empty then both org or profile name should exists.
      if (!self[:organization] || self[:organization].strip.length == 0) || (!self[:bootpolicyname] || self[:bootpolicyname].strip.length == 0)
        raise ArgumentError, "Either dn or both organization and policy name should be given in input."
      end
    end
  end
=end

end

