# --------------------------------------------------------------------------
# Access Mechanism
# --------------------------------------------------------------------------

This module uses the rest-client gem ( Version 1.6.7) to interact with the Ciscou UCS.

# --------------------------------------------------------------------------
#  Supported Functionality
# --------------------------------------------------------------------------

    - Power On
        
	- Power Off

# -------------------------------------------------------------------------
# Functionality Description
# -------------------------------------------------------------------------

  1. Power On
     The Power On method changes the power state from down to up for a service profile.  
   
  2. Power Off
     The Power off method changes the power state from up to down for a service profile.

# -------------------------------------------------------------------------
# Summary of Parameters.
# -------------------------------------------------------------------------
    
    username: (Required) This parameter defines the username as a part of the credentials of the host.            
    
	password: (Required) This parameter defines the password as a part of the credentials of the host.  
	
	server: (Required) This parameter defines the IP address of the host.   
	
    name: This parameter defines the name of the service profile.
    
    org: This parameter defines the source service profile path.
    
    dn: This pparameter defines the complete path of the source service profile including service profile name.
    
	power_state: This parameter defines the initial state of the service profile that needs to be changed as follows:

     Up to change the initial state to On.
     Down to change the initial state to Off.
	             
	             
	Note:- dn is a combination of the name and org, so the user needs to provide the values of either the dn or both the name and the org as a parameter.
          If a dn is not given by user, then the dn gets created automatically internally by the combination of org and the name, for example:
   
    if org is ' org-root' and name is 'testServiceProfile', then the dn shall be org-root/ls-testServiceProfile'
   

            
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
   
   Refer to the test directory.
   
   # puppet apply power_off.pp
   # puppet apply power_on.pp

#-------------------------------------------------------------------------------------------------------------------------
# End
#-------------------------------------------------------------------------------------------------------------------------   

