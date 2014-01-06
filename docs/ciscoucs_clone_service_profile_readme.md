# --------------------------------------------------------------------------
# Access Mechanism 
# --------------------------------------------------------------------------
 
This module uses the rest-client gem ( Version 1.6.7) to interact with the Cisco UCS.
 
# --------------------------------------------------------------------------
#  Supported Functionality
# --------------------------------------------------------------------------

 Clone Service Profile 
 
# -------------------------------------------------------------------------
# Functionality Description
# -------------------------------------------------------------------------
       
     Clone Service Profile - This functionally allows the user to create only one service profile with similar values to an existing service profile. An error message is displayed when a user tries to create multiple clone service profile's that rae already present.	 

# -------------------------------------------------------------------------
# Summary of Parameters.
# -------------------------------------------------------------------------
   clonename - This parameter defines the name of the new service profile name that is created after cloning the existing service profile.
   ensure - This parameter verifies whether or not a source service profile is present.  
     Possible values: present/absent    
   sourceserviceprofile -  This parameter defines the service profile that is to be cloned.
   targetorganizationname - This parameter expands the node for the organization where a service profile is to be created. If the system does not include multitenancy, expand the root node.
   sourceprofiledn - This parameter defines the complete path of the source service profile including the service profile using which a clone is to be created. 
   targetprofiledn - This parameter defines the complete path of the target profile (clone profile) including the clone profile name.
   sourceserviceprofilename - This parameter defines the name of the service profile using whih a clone is to be craeted. 
   sourceorganization - This parameter defines a path till source service profile.
   targetserviceprofilename - This parameter defines the name of the clone profile.
   targetorganization - This parameter defines the path till the  clone profile.
   
   Note:- 
      Sourceprofiledn is a combination of the sourceorganization and sourceserviceprofilename, so the user is required to provide values of either Sourceprofiledn or sourceorganization and sourceserviceprofilename as a parameter. If Sourceprofiledn is not provided by the user, then it automatically gets created by the combination of sourceorganization and sourceserviceprofilename, for example: if sourceserviceprofilename is 'testing' and sourceorganization is 'org-root/org-Finance', then the Sourceprofiledn shall be org-root/org-Finance/testing
	  In the same way, the targetprofiledn is a combination of the targetorganization and targetserviceprofilename, so the user is required to provide values of either targetprofiledn or targetorganization and targetserviceprofilename as a parameter.
	  If the targetprofiledn is not provided by the user, then it is automatically created using the combination of targetorganization and targetserviceprofilename, for example: if the targetserviceprofilename is 'clone' and the targetorganization is 'org-root/org-Finance/org-test1/org-test2', then the Sourceprofiledn shall be 'org-root/org-Finance/org-test1/org-test2/clone'
          
# -------------------------------------------------------------------------
# Parameter Signature 
# -------------------------------------------------------------------------
 
transport_ciscoucs { 'ciscoucs':
  username => $ciscoucs['username'],
  password => $ciscoucs['password'],
  server   => $ciscoucs['server'],
}
 
ciscoucs_serviceprofile_clone { 'sourceprofilename':
   ensure    =>  ${ciscoucs_serviceprofile_clone['ensure']},
   transport  => Transport_ciscoucs['ciscoucs'],
   sourceprofiledn => ${ciscoucs_serviceprofile_clone['sourceprofiledn']},
   targetprofiledn => ${ciscoucs_serviceprofile_clone['targetprofiledn']}, 
   sourceserviceprofilename      => ${ciscoucs_serviceprofile_clone['sourceserviceprofilename']},
   sourceorganization => ${ciscoucs_serviceprofile_clone['sourceorganization']},
   targetserviceprofilename   => ${ciscoucs_serviceprofile_clone['targetserviceprofilename']},
   targetorganization => ${ciscoucs_serviceprofile_clone['targetorganization']},
}

# --------------------------------------------------------------------------
# Usage
# --------------------------------------------------------------------------
   Refer to the test directory.
   
   # puppet apply ciscoucs_serviceprofile_clone.pp
 
#-------------------------------------------------------------------------------------------------------------------------
# End
#-------------------------------------------------------------------------------------------------------------------------
 