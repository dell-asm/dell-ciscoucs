# --------------------------------------------------------------------------
# Access Mechanism 
# --------------------------------------------------------------------------

This module uses the rest-client gem ( Version 1.6.7) to interact with the ciscoucs.

# --------------------------------------------------------------------------
#  Supported Functionality
# --------------------------------------------------------------------------

    - Power On
        
	- Power Off

# -------------------------------------------------------------------------
# Functionality Description
# -------------------------------------------------------------------------

  1. Power ON
     The Power on method changes the power state to down for a service profile.  
   
  2. Power Off
     The Power off method changes the power state to up for a service profile.

# -------------------------------------------------------------------------
# Summary of Parameters.
# -------------------------------------------------------------------------
    
	ensure: (Required) This parameter is required to call the Create or Destroy method.
    Possible values: Present/Absent
    If the value of the ensure parameter is set to present, the module calls the Create method.
    If the value of the ensure parameter is set to absent, the module calls the Destroy method.

    name: (Required) This parameter defines the name or IP address of the host that needs to be added or removed from the datacenter/cluster in the vCenter. If this parameter is not provided explicitly in the manifest file, then the title of the type 'vc_host' is used.    
    
	username: (Required) This parameter defines the username as a part of the credentials of the host.            
    
	password: (Required) This parameter defines the password as a part of the credentials of the host.            

	path: (Required) This parameter defines the path where the host needs to be added. The path should be an absolute path. If it is a datacenter path, then the host is added to the datacenter. If it is a cluster path, then the host is added to the respective Cluster. 
            
    sslthumbprint: (Optional) This parameter defines the SSL thumbprint of the host.
            
	secure: (Optional) This parameter defines whether or not the vCenter server must require SSL thumbprint verification of host. 
    Possible values: True/False
    Default: False
            
# -------------------------------------------------------------------------
# Parameter Signature 
# -------------------------------------------------------------------------

For Power on:

transport_ciscoucs { 'ciscoucs':
  username => $ciscoucs['username'],
  password => $ciscoucs['password'],
  server   => $ciscoucs['server'],
}


ciscoucs_serviceprofile { 'serviceprofilename':
   name => $serviceprofilename['name'], 
  ensure    => present,
  transport  => Transport_ciscoucs['ciscoucs'],
}


For Power off:

transport_ciscoucs { 'ciscoucs':
  username => $ciscoucs['username'],
  password => $ciscoucs['password'],
  server   => $ciscoucs['server'],
}


ciscoucs_serviceprofile { 'serviceprofilename':
  name => $serviceprofilename['name'], 
  ensure    => absent,
  transport  => Transport_ciscoucs['ciscoucs'],
}


# --------------------------------------------------------------------------
# Usage
# --------------------------------------------------------------------------
   
   Refer in the test directory.
   
   # puppet apply power_off.pp
   # puppet apply power_on.pp

#-------------------------------------------------------------------------------------------------------------------------
# End
#-------------------------------------------------------------------------------------------------------------------------   
