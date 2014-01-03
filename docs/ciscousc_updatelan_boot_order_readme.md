# --------------------------------------------------------------------------
# Access Mechanism
# --------------------------------------------------------------------------
 
   This module uses the  Ruby Rest Client Gem ( Version 1.6) to interact with the Cisco UCS.
 
# --------------------------------------------------------------------------
# Supported Functionality
# --------------------------------------------------------------------------

- Update LAN Boot Order

# -------------------------------------------------------------------------
# Functionality Description
# -------------------------------------------------------------------------
       
    This method describes how to set the server boot order.
	
# -------------------------------------------------------------------------
# Summary of Parameters.
# -------------------------------------------------------------------------
    bootpolicyname - This parameter defines the name of the boot policy that is to be modified.
    bootpolicyorganization - This parameter defines the source boot policy path.    
    bootpolicydn - This parameter defines the combination of bootpolicyorganization and bootpolicyname. Either a user is required to provide a value of the bootpolicydn or the values of the bootpolicyorganization and bootpolicyname as an input.
	lanorder - This parameter defines the priority of LAN to boot a server within the available multiple boot options (such as SAN).      
 
# -------------------------------------------------------------------------
# Parameter Signature
# -------------------------------------------------------------------------
 
transport_ciscoucs { 'ciscoucs':
  username => $ciscoucs['username'],
  password => $ciscoucs['password'],
  server   => $ciscoucs['server'],
}

cciscoucs_updatelan_boot_order{ 'dn':
  
  value => 'org-root/boot-policy-testbootpolicy',
  lanorder =>'4',
  #  value => 'testbootpolicy',
  transport  => Transport_ciscoucs['ciscoucs'],
}
 
# --------------------------------------------------------------------------
# Usage
# --------------------------------------------------------------------------
    Refer to the test directory.
   
   # puppet apply ciscoucs_updatelan_boot_order.pp
   
#-------------------------------------------------------------------------------------------------------------------------
# End
#-------------------------------------------------------------------------------------------------------------------------
 
