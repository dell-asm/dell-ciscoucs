Puppet::Type.newtype(:create_service_profile) do 
  @doc = "cisco ucs create server profile"
  
  Puppet.debug "testing ********"
    
  ensurable do
    newvalue(:present) do
      provider.create
      Puppet.debug "----1------"
    end

    newvalue(:absent) do
      provider.destroy
      Puppet.debug "----2 ------"
    end
  end
  
  newparam(:name) do
    desc "name of server profile"
  end

  newparam(:agentpolicyname) do
    desc "The space reservation mode."
  end

  newparam(:biosprofilename) do
    desc "The space reservation mode."
  end
  Puppet.debug "testing 1********"
    newparam(:bootpolicyname) do
    desc "The space reservation mode."
  end

    newparam(:descr) do
    desc "The space reservation mode."
  end

    newparam(:dn) do
    desc "The space reservation mode."
  end

    newparam(:dynamicconpolicyname) do
    desc "The space reservation mode."
  end

    newparam(:extippoolname) do
    desc "The space reservation mode."
  end

    newparam(:extipstate) do
    desc "The space reservation mode."
  end

    newparam(:hostfwpolicyname) do
    desc "The space reservation mode."
  end

    newparam(:identpoolname) do
    desc "The space reservation mode."
  end

    newparam(:localdiskpolicyname) do
    desc "The space reservation mode."
  end
  
      newparam(:maintpolicyname) do
    desc "The space reservation mode."
  end

      newparam(:mgmtaccessPolicyname) do
    desc "The space reservation mode."
  end

      newparam(:mgmtfwpolicyname) do
    desc "The space reservation mode."
  end

      newparam(:policyowner) do
    desc "The space reservation mode."
  end

      newparam(:powerpolicyname) do
    desc "The space reservation mode."
  end

   newparam(:scrubpolicyname) do
    desc "The space reservation mode."
  end

   newparam(:solpolicyname) do
    desc "The space reservation mode."
  end

  newparam(:srctemplname) do
    desc "The space reservation mode."
  end

  newparam(:statspolicyname) do
    desc "The space reservation mode."
  end

  newparam(:status) do
    desc "The space reservation mode."
  end

   newparam(:usrlbl) do
    desc "The space reservation mode."
  end

   newparam(:uuid) do
    desc "The space reservation mode."
  end

  newparam(:vconprofilename) do
    desc "The space reservation mode."
  end
end
