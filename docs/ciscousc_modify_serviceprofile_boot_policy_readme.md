# --------------------------------------------------------------------------
# Access Mechanism
# --------------------------------------------------------------------------
 
   This module uses the  Ruby Rest Client Gem ( Version 1.6) to interact with the Cisco UCS.
 
# --------------------------------------------------------------------------
# Supported Functionality
# --------------------------------------------------------------------------

- Modify Serviceprofile Boot Policy

# -------------------------------------------------------------------------
# Functionality Description
# -------------------------------------------------------------------------
       
    This method assigns an existing boot policy to the service profile. If a user selects this option, the Cisco UCS Manager displays the details of the policy.
	
# -------------------------------------------------------------------------
# Summary of Parameters.
# -------------------------------------------------------------------------
    bootpolicyname - This parameter defines the name of the boot policy that is to be modified.
    bootpolicyorganization - This parameter defines the source boot policy path.
    ensure -   
        value: modify   
    bootpolicydn - This parameter is a combination of the  bootpolicyorganization and the bootpolicyname. Either a user is required to provide the value of bootpolicydn or the values of bootpolicyorganization and bootpolicyname  as an input.
    serviceprofilename -  This parameter describes the name of the service profile that is to be applied.
    serviceprofileorganization - This parameter describes the source service profile path.
    serviceprofiledn - This parameter defines a combination of the serviceprofileorganization and serviceprofilename. Either a user is required to provide the value of the serviceprofiledn or the values of serviceprofileorganization and serviceprofilename as an input.
 
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
    Refer to the test directory.
   
   # puppet apply ciscoucs_modify_serviceprofile_boot_policy.pp
   
#-------------------------------------------------------------------------------------------------------------------------
# End
#-------------------------------------------------------------------------------------------------------------------------
 
