# --------------------------------------------------------------------------
# Access Mechanism
# --------------------------------------------------------------------------
 
This module uses the  Ruby Rest Client Gem ( Version 1.6) to interact with the Cisco UCS.
 
# --------------------------------------------------------------------------
#  Supported Functionality
# --------------------------------------------------------------------------

- Associate Service Profile
- Disassociate Service Profile

# -------------------------------------------------------------------------
# Functionality Description
# -------------------------------------------------------------------------
       
     Associate Service Profile - This method allows a user to apply a service profile on the server pool or a chassis slot. If an issue arises while applying aservice profile on a server pool or chassis slot, an error message is generated.
	
	 Disassociate Service Profile- This method allows the user to disassociate a service profile on a server pool or chassis slot. If an issue arises while disassociating a service profile on a server pool or chassis slot, an error message gets generated.
	
# -------------------------------------------------------------------------
# Summary of Parameters.
# -------------------------------------------------------------------------
   organization_name - This parameter describes the source service profile path.
   ensure - This parameter makes sure that no service profile is applied to the server pool or chassis slot in case of an associate server profile.It also makes sure that a service profile is applied to the server pool or chassis slot in case of disassociate server profile.
       Possible values: present/absent
   service_profile_name - This parameter defines the name of the service profile that is to be applied.
   profile_dn - This parameter describes a complete path of the source service profile including the service profile name.
   server_chesis_id - This parameter defines the name where the server profile is to be associated or disassociated from the selected server pool.
   server_slot - This parameter defines the server pool that is to be associated/disassociated witha a server profile.
   server_dn - This parameter defines the complete path of the  server.
   
   
 
# -------------------------------------------------------------------------
# Parameter Signature
# -------------------------------------------------------------------------
 
 Associate Service Profile:
 
transport_ciscoucs { 'ciscoucs':
  username => $ciscoucs['username'],
  password => $ciscoucs['password'],
  server   => $ciscoucs['server'],
}
 
ciscoucs_serviceprofile_association { 'name':
  ensure    => "${ciscoucs_profile_association_dissociation['ensure_present']}", 
  organization_name => "${ciscoucs_profile_association_dissociation['organization_name']}",
  service_profile_name => "${ciscoucs_profile_association_dissociation['service_profile_name']}",
  profile_dn => "${ciscoucs_profile_association_dissociation['profile_dn']}",
  server_chassis_id => "${ciscoucs_profile_association_dissociation['server_chassis_id']}",
  server_slot_id => "${ciscoucs_profile_association_dissociation['server_slot_id']}",   
  server_dn => "${ciscoucs_profile_association_dissociation['server_dn']}",
  transport  => "${ciscoucs_profile_association_dissociation['transport']}",
}



 Disassociate Service Profile:
 
transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}", 
}

ciscoucs_serviceprofile_association { 'name':
  ensure    => "${ciscoucs_profile_association_dissociation['ensure_absent']}", 
  organization_name => "${ciscoucs_profile_association_dissociation['organization_name']}",
  service_profile_name => "${ciscoucs_profile_association_dissociation['service_profile_name']}",
  profile_dn => "${ciscoucs_profile_association_dissociation['profile_dn']}",
  server_chassis_id => "${ciscoucs_profile_association_dissociation['server_chassis_id']}",
  server_slot_id => "${ciscoucs_profile_association_dissociation['server_slot_id']}",   
  server_dn => "${ciscoucs_profile_association_dissociation['server_dn']}",
  transport  => "${ciscoucs_profile_association_dissociation['transport']}",
}
 
# --------------------------------------------------------------------------
# Usage
# --------------------------------------------------------------------------
    Refer to the test directory.
   
   # puppet apply associate_profile.pp
   # puppet apply disassociate_profile.pp
#-------------------------------------------------------------------------------------------------------------------------
# End
#-------------------------------------------------------------------------------------------------------------------------
 
