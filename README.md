# Cisco UCS module

This module manages resources in ciscoucs.

## Description

This module manages resources in ciscoucs.

## Installation

This module uses the rest-client gem ( Version 1.6.7) to interact with the ciscoucs.


## Usage



All ciscoucs resources use the transport metaparameter to specify the
connectivity used to manage the resource:

    transport_ciscoucs { 'ciscoucs':
    username => $ciscoucs['username'],
    password => $ciscoucs['password'],
    server   => $ciscoucs['server'],
}




See tests folder for additional examples.

## References
Following functionality related readme's are kept at docs folder.

1) ciscoucs_clone_service_profile_readme.md: This readme file talks about following ciscoucs functionalities.
   a) This functionally allows user to create only one service profile with similar values to an existing service profile. 
      Error message is displayed when user try to create multiple Service Profile with the same name, which is already present.	 
 
   
2) ciscoucs_serviceprofile_power_readme.md: This readme file talks about following ciscoucs functionalities.
   a) Power On: Changes the power state to UP for a service profile.  
   b) Power Off: Changes the power state to DOWN for a service profile.  
    
3) ciscousc_associate_disassociate_readme.md: This readme file describes following host system functionalities.
   a)  Associate Service Profile- Associate service profile allows user to apply service profile on server pool or chassis slot. 
       In case while applying service profile on a server pool or chassis slot any error occurred, than proper error message will be generated. 
   b)  Disassociate Service Profile- Disassociate service profile allows user to disassociate service profile on server pool or chassis slot. 
       In case while disassociating service profile on a server pool or chassis slot any error occurred, than proper error message will be generated.
	 
   

   

