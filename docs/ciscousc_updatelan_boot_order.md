# --------------------------------------------------------------------------
# Access Mechanism 
# --------------------------------------------------------------------------
 
   This module uses the  Ruby Rest Client Gem ( Version 1.6) to interact with the Ciscousc.
 
# --------------------------------------------------------------------------
# Supported Functionality
# --------------------------------------------------------------------------

- update LAN boot order

# -------------------------------------------------------------------------
# Functionality Description
# -------------------------------------------------------------------------
       
     It describes how to set the server boot order.
	 
# -------------------------------------------------------------------------
# Summary of Parameters.
# -------------------------------------------------------------------------
    bootpolicyname - Name of the boot policy which user wants to modify.
    bootpolicyorganization - Source boot policy path.    
    bootpolicydn - It's a combination of bootpolicyorganization and bootpolicyname. Either user have to provide value of bootpolicydn or values of bootpolicyorganization and bootpolicyname  as an input.
	lanorder - Priority of LAN in order to boot a server within available multiple boot options (such as SAN)      
 
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
    Refer in the test directory.
   
   # puppet apply ciscoucs_updatelan_boot_order.pp
   
#-------------------------------------------------------------------------------------------------------------------------
# End
#-------------------------------------------------------------------------------------------------------------------------
 