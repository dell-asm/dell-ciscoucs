# --------------------------------------------------------------------------
# Access Mechanism 
# --------------------------------------------------------------------------

This module uses the rest-client gem ( Version 1.6.7) to interact with the ciscoucs.

# --------------------------------------------------------------------------
#  Supported Functionality
# --------------------------------------------------------------------------
   - Create

# -------------------------------------------------------------------------
# Functionality Description
# -------------------------------------------------------------------------

  

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




# --------------------------------------------------------------------------
# Usage
# --------------------------------------------------------------------------
   
   Refer in the test directory.
   
  

#-------------------------------------------------------------------------------------------------------------------------
# End
#-------------------------------------------------------------------------------------------------------------------------   
