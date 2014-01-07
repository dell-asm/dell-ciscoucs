# --------------------------------------------------------------------------
# Access Mechanism 
# --------------------------------------------------------------------------

This module uses the rest-client gem ( Version 1.6.7) to interact with the ciscoucs.

# --------------------------------------------------------------------------
#  Supported Functionality
# --------------------------------------------------------------------------
   - Create Service Profile

# -------------------------------------------------------------------------
# Functionality Description
# -------------------------------------------------------------------------

  Service Profile form Template:
  
  With a service profile template, service profiles can be created with the same basic parameters, such as the number of vNICs and vHBAs, and with identity information drawn from the same pools. 
  
  
  Service Profile from Server: 
  
  With existing server service profile can be created.
   

# -------------------------------------------------------------------------
# Summary of Parameters.
# -------------------------------------------------------------------------


    username: (Required) This parameter defines the username as a part of the credentials of the host.            
    
    password: (Required) This parameter defines the password as a part of the credentials of the host.  
	
    server: (Required) This parameter defines the ip address the host.   
	
    serviceprofile_name: This parameter defines the name of the service profile.
    
    organization: Source service profile path.
    
    ensure: (Required) This parameter is required to call the Create or Destroy method.
    Possible values: Present/Absent
    If the value of the ensure parameter is set to present, the module calls the Create method.
    If the value of the ensure parameter is set to absent, the module calls the Destroy method.
 
    profile_dn: This parameter defines the complete path of the service profile. 
    
    source_template: Template name from which service profile needs to be created
	
    server_chassis_id: Server Chassis id of serouce server from which service profile needs to be created.
  
    server_slot: Server slot of the source server from which service profile needs to be created.
    
    number_of_profiles: Number of profiles to be created in case of create profile from template
    
    Note:
    
    a)If the dn is not provided by the user, then it is automatically created using the combination of name and org, 
     So it is mandatory to give either (dn) or both (name and org).
     
    b)In case of create server profile from template: the created profile will add numerics to its name if profile with that name
     already exists.
     For example: if parameter name is given as 'newprofile' then the created profile will be of name 'newprofile1' 
            
# -------------------------------------------------------------------------
# Parameter Signature 
# -------------------------------------------------------------------------


Service profile from template:

transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}",
 
}


ciscoucs_serviceprofile { 'name':
  serviceprofile_name   => "${ciscoucs_serviceprofile['name']}",
  organization          => "${ciscoucs_serviceprofile['org']}",
  profile_dn            => "${ciscoucs_serviceprofile['dn']}",
  ensure                => "${ciscoucs_serviceprofile['ensure']}",
  source_template       => "${ciscoucs_serviceprofile['source_template']}",
  transport             => Transport_ciscoucs['ciscoucs'],
  number_of_profiles    => "${ciscoucs_serviceprofile['number_of_profiles']}",
}


Service profile from existing server:

transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}",
 
}

ciscoucs_serviceprofile { 'name':
  serviceprofile_name   => "${ciscoucs_serviceprofile['name']}",
  organization          => "${ciscoucs_serviceprofile['org']}",
  profile_dn            => "${ciscoucs_serviceprofile['dn']}",
  server_chassis_id     => "${ciscoucs_serviceprofile['server_chassis_id']}",
  server_slot           => "${ciscoucs_serviceprofile['server_slot']}",
  ensure                => "${ciscoucs_serviceprofile['ensure']}",
  transport             => Transport_ciscoucs['ciscoucs'],
}


# --------------------------------------------------------------------------
# Usage
# --------------------------------------------------------------------------
   
    Refer in the test directory.
   
   # puppet apply create_profile_server.pp
   # puppet apply create_profile_template.pp
   

#-------------------------------------------------------------------------------------------------------------------------
# End
#-------------------------------------------------------------------------------------------------------------------------   
