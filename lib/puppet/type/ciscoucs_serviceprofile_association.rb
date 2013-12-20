Puppet::Type.newtype(:ciscoucs_serviceprofile_association) do
  @doc = 'Associate service profile Associate on cisco ucs device'
  
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
     desc 'server profile Parameter'
     newvalues(/\w/)
   end
   
  newparam(:organizationname) do
       desc 'server profile Parameter'
       newvalues(/\w/)
     end

  newparam(:serviceprofilename) do
         desc 'server profile Parameter'
         newvalues(/\w/)
       end
       
  newparam(:dnorganizationname) do
         desc 'server profile Parameter'
         newvalues(/\w/)
       end
       
  newparam(:dnserviceprofilename) do
         desc 'server profile Parameter'
         newvalues(/\w/)
       end
       
  newparam(:serverchesisid) do
         desc 'server profile Parameter'
         newvalues(/\w/)
       end
       
  newparam(:serverslot) do
           desc 'server profile Parameter'
           newvalues(/\w/)
         end
         
end
