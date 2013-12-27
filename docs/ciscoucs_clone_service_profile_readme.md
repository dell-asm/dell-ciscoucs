# --------------------------------------------------------------------------
# Access Mechanism 
# --------------------------------------------------------------------------
 
This module uses the rest-client gem ( Version 1.6.7) to interact with the ciscoucs.
 
# --------------------------------------------------------------------------
#  Supported Functionality
# --------------------------------------------------------------------------

 Clone Service Profile 
 
# -------------------------------------------------------------------------
# Functionality Description
# -------------------------------------------------------------------------
       
     Clone Service Profile- This functionally allows user to create only one service profile with similar values to an existing service profile. Error message is displayed when user try to create multiple clone Service Profile which is already present.	 

# -------------------------------------------------------------------------
# Summary of Parameters.
# -------------------------------------------------------------------------
   clonename - name of the new service profile name which will be created after cloning of any existing service profile.
   ensure -  ensure whether source service profile is present or not 
     Possible values: present/absent    
   sourceserviceprofile -   Service profile user wants to clone.
   targetorganizationname - Expand the node for the organization where user want to create the service profile. If the system does not include multitenancy, expand the root node.
 
# -------------------------------------------------------------------------
# Parameter Signature 
# -------------------------------------------------------------------------
 
transport_ciscoucs { 'ciscoucs':
  username => $ciscoucs['username'],
  password => $ciscoucs['password'],
  server   => $ciscoucs['server'],
}
 
ciscoucs_serviceprofile_clone { 'serviceprofileclone':
   clonename => $serviceprofileclone [clone_name], 
   ensure    => present,
   transport  => Transport_ciscoucs['ciscoucs'],
   sourceserviceprofile      => $serviceprofile [name],
   targetorganizationname => $serviceprofileclone [path],
}
 
# --------------------------------------------------------------------------
# Usage
# --------------------------------------------------------------------------
   Refer in the test directory.
   
   # puppet apply ciscoucs_serviceprofile_clone.pp
 
#-------------------------------------------------------------------------------------------------------------------------
# End
#-------------------------------------------------------------------------------------------------------------------------
 