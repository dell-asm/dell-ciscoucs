# --------------------------------------------------------------------------
# Access Mechanism 
# --------------------------------------------------------------------------
 
This module uses the  Ruby Rest Client Gem ( Version 1.6) to interact with the Ciscousc.
 
# --------------------------------------------------------------------------
#  Supported Functionality
# --------------------------------------------------------------------------

- modify serviceprofile boot policy

# -------------------------------------------------------------------------
# Functionality Description
# -------------------------------------------------------------------------
       
     
	 
# -------------------------------------------------------------------------
# Summary of Parameters.
# -------------------------------------------------------------------------
   bootpolicyname - Name of the boot policy which user wants to modify.
   bootpolicyorganization - Source boot policy path.
   ensure -   
       Possible values: present/absent 
   
   bootpolicydn - It's a combination of bootpolicyorganization and bootpolicyname. Either user have to provide value of bootpolicydn or values of bootpolicyorganization and bootpolicyname  as an input.
   serviceprofilename -  Name of the service profile which user wants to apply.
   serviceprofileorganization - Source service profile path.
   serviceprofiledn - It's a combination of serviceprofileorganization and serviceprofilename. Either user have to provide value of serviceprofiledn or values of serviceprofileorganization and serviceprofilename as an input.
 
# -------------------------------------------------------------------------
# Parameter Signature 
# -------------------------------------------------------------------------
 
transport_ciscoucs { 'ciscoucs':
  username => $ciscoucs['username'],
  password => $ciscoucs['password'],
  server   => $ciscoucs['server'],
}

ciscoucs_modify_serviceprofile_boot_policy { 'serviceprofilename':
   ensure    => modify,
   transport  => Transport_ciscoucs['ciscoucs'],
   bootpolicydn => 'org-root/boot-policy-test_boot_policy',
   bootpolicyname => 'test_boot_policy',
   bootpolicyorganization => 'org-root',
   serviceprofiledn => 'org-root/ls-testing',
   serviceprofilename => 'testing',
   serviceprofileorganization => 'org-root',
}
 
# --------------------------------------------------------------------------
# Usage
# --------------------------------------------------------------------------
    Refer in the test directory.
   
   # puppet apply ciscoucs_modify_serviceprofile_boot_policy.pp
   
#-------------------------------------------------------------------------------------------------------------------------
# End
#-------------------------------------------------------------------------------------------------------------------------
 