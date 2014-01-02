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
	
    name: This parameter defines the name of the service profile.
    
    org: Source service profile path.
    
	ensure: (Required) This parameter is required to call the Create or Destroy method.
    Possible values: Present/Absent
    If the value of the ensure parameter is set to present, the module calls the Create method.
    If the value of the ensure parameter is set to absent, the module calls the Destroy method.

    name: (Required) This parameter defines the name or IP address of the host that needs to be added or removed from the datacenter/cluster in the vCenter. If this parameter is not provided explicitly in the manifest file, then the title of the type 'vc_host' is used.    
    
	source_template: Template name from which service profile needs to be created
	
	server_chassis_id => Server Chassis id of serouce server from which service profile needs to be created.
  
    server_slot: Server slot of the source server from which service profile needs to be created.
            
# -------------------------------------------------------------------------
# Parameter Signature 
# -------------------------------------------------------------------------


Service profile from template:

transport_ciscoucs { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '192.168.24.130',
}


ciscoucs_serviceprofile { 'name':
  name            => 'create_prof',
  org             => 'org-root',
  ensure          => present,
  source_template => 'test_temp',
  transport       => Transport_ciscoucs['ciscoucs'],
}


Service profile from existing server:

transport_ciscoucs { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '192.168.241.131',
}


ciscoucs_serviceprofile { 'name':
  name            => 'SP1',
  org             => 'org-root',
  ensure          => present,
  server_chassis_id => 'chassis-1',
  server_slot => 'blade-1',   
  transport       => Transport_ciscoucs['ciscoucs'],
}



# --------------------------------------------------------------------------
# Usage
# --------------------------------------------------------------------------
   
   Refer in the test directory.
   
  

#-------------------------------------------------------------------------------------------------------------------------
# End
#-------------------------------------------------------------------------------------------------------------------------   
