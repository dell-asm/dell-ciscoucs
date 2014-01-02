# --------------------------------------------------------------------------
# Access Mechanism 
# --------------------------------------------------------------------------
 
This module uses the  Ruby Rest Client Gem ( Version 1.6) to interact with the Ciscousc.
 
# --------------------------------------------------------------------------
#  Supported Functionality
# --------------------------------------------------------------------------

- Associate Service Profile 
- Disassociate Service Profile

# -------------------------------------------------------------------------
# Functionality Description
# -------------------------------------------------------------------------
       
     Associate Service Profile- Associate service profile allows user to apply service profile on server pool or chassis slot. In case while applying service profile on a server pool or chassis slot any error occurred, than proper error message will be generated. 
	 
	 Disassociate Service Profile- Disassociate service profile allows user to disassociate service profile on server pool or chassis slot. In case while disassociating service profile on a server pool or chassis slot any error occurred, than proper error message will be generated.
	 
# -------------------------------------------------------------------------
# Summary of Parameters.
# -------------------------------------------------------------------------
   organization_name - source service profile path
   ensure -   ensures any service profile is not applied to the server pool or chassis slot in case of associate server profile.
              ensures any service profile is applied to the server pool or chassis slot in case of disassociate server profile.
       Possible values: present/absent 
   service_profile_name -  name of the service profile which user wants to apply.
   profile_dn - Complete path of source service profile including service profile name.
   server_chesis_id - name of the  on which server profile will be associated or disassociated from the selected server pool.
   server_slot - server pool user wants to associate/disassociate server profile
   server_dn - Complete path of server.
 
# -------------------------------------------------------------------------
# Parameter Signature 
# -------------------------------------------------------------------------
 
 Associate Service Profile 
 
transport_ciscoucs { 'ciscoucs':
  username => $ciscoucs['username'],
  password => $ciscoucs['password'],
  server   => $ciscoucs['server'],
}
 
ciscoucs_serviceprofile_association { 'serviceprofile':
  ensure    => absent, 
  organization_name => $organization['parent folder'],
  service_profile_name => $serviceprofile['name'],
  profile_dn => '',
  server_chesis_id => $chassis['id'],
  server_slot => $serverpool['name'],   
  server_dn => '',
  transport  => Transport_ciscoucs['ciscoucs'],
}

 Disassociate Service Profile
 
transport_ciscoucs { 'ciscoucs':
  username => $ciscoucs['username'],
  password => $ciscoucs['password'],
  server   => $ciscoucs['server'],
}

ciscoucs_serviceprofile_association { 'serviceprofile':
  ensure    => absent, 
  organization_name => $organization['parent folder'],
  service_profile_name => $serviceprofile['name'],
  profile_dn => '',
  server_chesis_id => $chassis['id'],
  server_slot => $serverpool['name'], ,   
  server_dn => '',
  transport  => Transport_ciscoucs['ciscoucs'],
}
 
# --------------------------------------------------------------------------
# Usage
# --------------------------------------------------------------------------
    Refer in the test directory.
   
   # puppet apply associate_profile.pp
   # puppet apply disassociate_profile.pp
#-------------------------------------------------------------------------------------------------------------------------
# End
#-------------------------------------------------------------------------------------------------------------------------
 