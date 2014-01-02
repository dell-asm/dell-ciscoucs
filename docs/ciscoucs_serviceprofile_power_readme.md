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
    
    username: (Required) This parameter defines the username as a part of the credentials of the host.            
    
	password: (Required) This parameter defines the password as a part of the credentials of the host.  
	
	server: (Required) This parameter defines the ip address the host.   
	
    name: This parameter defines the name of the service profile.
    
    org: Source service profile path.
    
    dn: Complete path of source service profile including service profile name.
    
	power_state: Initial state of the service profile that needs to be changed.
	             Up to change the initial state to On
	             Down to change the initial state to Off
	             
	             
	Note:- dn is a combination of name and org, hence user needs to give values of either dn or both name and 
          org as a parameter. 
          If dn is not given by user than dn will be internally automatically created by combination of org and name.
   
    Example:- if org is ' org-root' and name is 'testServiceProfile' then dn will be org-root/ls-testServiceProfile'
   

            
# -------------------------------------------------------------------------
# Parameter Signature 
# -------------------------------------------------------------------------

For Power on:

transport_ciscoucs { 'ciscoucs':
  username => $ciscoucs['username'],
  password => $ciscoucs['password'],
  server   => $ciscoucs['server'],
}


ciscoucs_serviceprofile { 'name':
   name  => ${ciscoucs_serviceprofile['name']}, 
   org   => ${ciscoucs_serviceprofile['org']}, 
   dn    => ${ciscoucs_serviceprofile['dn']}, 
   power_state   => ${ciscoucs_serviceprofile['power_state_on']},  
   transport   => Transport_ciscoucs['ciscoucs'],
}



For Power off:

transport_ciscoucs { 'ciscoucs':
  username => $ciscoucs['username'],
  password => $ciscoucs['password'],
  server   => $ciscoucs['server'],
}


ciscoucs_serviceprofile { 'name':
  name   => ${ciscoucs_serviceprofile['name']},
  org    => ${ciscoucs_serviceprofile['org']},
  dn     => ${ciscoucs_serviceprofile['dn']},
  power_state   => ${ciscoucs_serviceprofile['power_state_off']},
  transport   => Transport_ciscoucs['ciscoucs'],
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
