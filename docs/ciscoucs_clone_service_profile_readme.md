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
   sourceprofiledn - Complete path of source service profile including service profile name by which user wants to create a clone.
   targetprofiledn - Complete path of target profile (clone profile) including clone profile name.
   sourceserviceprofilename - Name of service profile by which user wants to create a clone.
   sourceorganization - Path till source service profile.
   targetserviceprofilename - Name of clone profile.
   targetorganization - Path till clone profile.
   
   Note:- Sourceprofiledn is a combination of sourceorganization and sourceserviceprofilename, hence user needs to give values of either Sourceprofiledn or sourceorganization and 
          sourceserviceprofilename as a parameter. If Sourceprofiledn is not given by user than it will be automatically created by combination of sourceorganization and sourceserviceprofilename.
   Example:- if sourceserviceprofilename is 'testing' and sourceorganization is 'org-root/org-Finance'
              than Sourceprofiledn will be org-root/org-Finance/testing

	  In the same way targetprofiledn is a combination of targetorganization and targetserviceprofilename, hence user needs to give
	  values of either targetprofiledn or targetorganization and targetserviceprofilename as a parameter.
	  If targetprofiledn is not given by user than it will be automatically created by combination of targetorganization and targetserviceprofilename.
   Example:- if targetserviceprofilename is 'clone' and targetorganization is 'org-root/org-Finance/org-test1/org-test2'
              than Sourceprofiledn will be 'org-root/org-Finance/org-test1/org-test2/clone'
          
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
   sourceprofiledn => '',
   targetprofiledn => '',
   sourceserviceprofilename      => 'testing',
   sourceorganization => 'org-root/org-Finance',
   targetserviceprofilename      => 'clone',
   targetorganization => 'org-root/org-Finance/org-test1/org-test2',
}

# --------------------------------------------------------------------------
# Usage
# --------------------------------------------------------------------------
   Refer in the test directory.
   
   # puppet apply ciscoucs_serviceprofile_clone.pp
 
#-------------------------------------------------------------------------------------------------------------------------
# End
#-------------------------------------------------------------------------------------------------------------------------
 