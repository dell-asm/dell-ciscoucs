# Cisco Unified Computing System (Cisco UCS) module

This module manages the resources in Cisco UCS.


**Table of Contents**

- [Cisco UCS module](#ciscoucs-module)
	- [Overview](#overview)
	- [Requirements](#requirements)
    - [Features](#features)
    - [Service Profile](#service-profile)
		- [Create Service Profile](#create-service-profile)
		- [Clone Service Profile](#clone-service-profile)
        - [Associate / Disassociate Service Profile](#asso-disasso-service-profile)
        - [Power On / Off ](#on-off) 
	- [Boot Policy](#boot-policy)
	    - [Modify service profile boot policy](#modify-boot-policy)
	    - [Modify service profile boot order](#modify-boot-order)
        

## Overview

The Cisco UCS Manager is the management system for all components in a Cisco UCS domain. A Cisco UCS Manager runs within the fabric interconnect. You can use any of the interfaces available with this management service, to access, configure, administer, and monitor the network and server resources for all chassis connected to the fabric interconnect.

This module was developed by Dell which is why the name of the repo starts with dell-.   The name dell-ciscoucs does not imply a partnership, agreement or other special relationship between Dell and Cisco.  Cisco UCS® is a registered trademark of Cisco Systems, Inc.
 
 
## Requirements

 The requirements to interact with the Cisco UCS are as follows: 

 * rest-client gem ( Version 1.6.7)
 * rubysl-rexml gem (Version 2.0.2)

## Features

The following items are supported:

 * Creation of service profile from the existing server.
 * Creation of service profile from the template.
 * Cloning of a service profile.
 * Association of a service profile.
 * Disassociation of a service profile. 
 * Power on/off.
 * Updation of service profile boot policy.
 * Updation of service profile boot order(LAN).


###Service Profile

Cisco Unified Computing System service profiles are a powerful tool for streamlining the management of modern data centers. They provide a mechanism for rapidly provisioning servers and their associated network and storage connections with consistency in all details of the environment, and they can be set up in advance before the physical installation of the servers.

###Cisco UCS Create Service Profile:

To create a service profile, the following two methods are mentioned below: 

######Create a service profile from an existing server:

This profile uses the default values in the server and mimics the management of a rack-mounted server. It is tied to a specific server and cannot be moved or migrated to another server.This service profile inherits and applies the identity and configuration information that is present at the time of association, such as BIOS Versions, Server UUID, MAC addresses etc.

######Create a service profile from the template:

Service profile templates are used to simplify the creation of new service profiles, helping ensure consistent policies within the system for a given service or application. 


####Summary of Parameters

#####Cisco UCS Create Service Profile

1. serviceprofile_name: This parameter defines the name of the service profile.

2. organization: This parameter defines the source service profile path. A valid format is 'org-root'.

3. ensure: (Required) This parameter is required to call the Create or Destroy method.
           Possible values: Present/Absent
           If the value of the ensure parameter is set to present, the module calls the Create method.
           If the value of the ensure parameter is set to absent, the module calls the Destroy method.
 
4. profile_dn: This parameter defines the complete path of the service profile. 

5. source_template: This parameter defines the template name from which the service profile is to be created.

6. server_chassis_id: The parameter defines the server chassis id of the source server from which the service profile needs to be created.

7. server_slot: This paramerter defines the server slot of the source server from which the service profile needs to be created.

8. number_of_profiles: This parameter defines the number of profiles to be created in case of the create profile from template.

####Usage

The create service profile module can be used by calling the ciscoucs_serviceprofile_server.pp and the ciscoucs_serviceprofile_template.pp, as 
shown in the example below:

######Create a service profile from the server

```

transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}", 
}

ciscoucs_serviceprofile { 'name':
  serviceprofile_name  => "${ciscoucs_serviceprofile['serviceprofile_name']}",
  organization         => "${ciscoucs_serviceprofile['organization']}",
  profile_dn           => "${ciscoucs_serviceprofile['profile_dn']}",
  server_chassis_id    => "${ciscoucs_serviceprofile['server_chassis_id']}",
  server_slot          => "${ciscoucs_serviceprofile['server_slot']}",
  ensure               => "${ciscoucs_serviceprofile['ensure']}",
  transport            => Transport_ciscoucs['ciscoucs'],
}
```
######Create a service profile from the template

```
transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}",
}

ciscoucs_serviceprofile { 'name':
  serviceprofile_name        => "${ciscoucs_serviceprofile['serviceprofile_name']}",
  organization               => "${ciscoucs_serviceprofile['organization']}",
  profile_dn                 => "${ciscoucs_serviceprofile['profile_dn']}",
  ensure                     => "${ciscoucs_serviceprofile['ensure']}",
  source_template            => "${ciscoucs_serviceprofile['source_template']}",
  transport                  => Transport_ciscoucs['ciscoucs'],
  number_of_profiles         => "${ciscoucs_serviceprofile['number_of_profiles']}",
}
```
### Cisco UCS Clone Service Profile:

This functionally allows the user to create only one service profile with similar values, to an existing service profile. 
An error message is displayed when a user tries to create multiple Service profiles with the same name, which is already present.

####Summary of Parameters

#####Cisco UCS clone service profile:


1. ensure: This parameter verifies whether or not a source service profile is present.  
            Possible values: present/absent
            
2. sourceserviceprofile: This parameter defines the service profile that is to be cloned.

3. source_profile_dn: This parameter defines the complete path of the source service profile including the service profile using which a clone is to be created. 

4. target_profile_dn: This parameter defines the complete path of the target profile (clone profile) including the clone profile name.

5. source_serviceprofile_name: This parameter defines the name of the service profile using whih a clone is to be craeted.

6. source_organization: This parameter defines a path till source service profile. A valid format is 'org-root'.

7. target_serviceprofile_name: This parameter defines the name of the clone profile.

9. target_organization: This parameter defines the path till the  clone profile. A valid format is 'org-root'.


####Usage

The clone service profile module can be used by calling the ciscoucs_serviceprofile_clone.pp, as 
shown in the example below:

######Clone service profile from server

```
transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}",
}

ciscoucs_serviceprofile_clone { 'source_profile_name':
  ensure                     => "${ciscoucs_serviceprofile_clone['ensure']}",
  transport                  => Transport_ciscoucs['ciscoucs'],
  source_profile_dn          => "${ciscoucs_serviceprofile_clone['source_profile_dn']}",
  target_profile_dn          => "${ciscoucs_serviceprofile_clone['target_profile_dn']}",
  source_serviceprofile_name => "${ciscoucs_serviceprofile_clone['source_serviceprofile_name']}",
  source_organization        => "${ciscoucs_serviceprofile_clone['source_organization']}",
  target_serviceprofile_name => "${ciscoucs_serviceprofile_clone['target_serviceprofile_name']}",
  target_organization        => "${ciscoucs_serviceprofile_clone['target_organization']}",
}

```
###Cisco UCS Associate/Disassociate Service Profile:

#####Associate Service Profile

This method allows a user to apply a service profile on the server pool or a chassis slot. If an issue arises while applying aservice profile on a server pool or chassis slot, an error message is generated.

#####Disassociate Service Profile

This method allows the user to disassociate a service profile on a server pool or chassis slot. If an issue arises while disassociating a service profile on a server pool or chassis slot, an error message gets generated.

####Summary of Parameters

#####Cisco UCS Associate/Disassociate service profile:

1. organization: This parameter describes the source service profile path. A valid format is 'org-root'.

2. ensure: This parameter makes sure that no service profile is applied to the server pool or chassis slot in case of an associate server profile.It also makes sure that a service profile is applied to the server pool or chassis slot in case of disassociate server profile.
       Possible values: present/absent
   
3. serviceprofile_name: This parameter defines the name of the service profile that is to be applied.

4. profile_dn: This parameter describes a complete path of the source service profile including the service profile name.

5. server_chesis_id: This parameter defines the name where the server profile is to be associated or disassociated from the selected server pool.

6. server_slot: This parameter defines the server pool that is to be associated/disassociated witha a server profile.
   
7. server_dn: This parameter defines the complete path of the  server.

####Usage

The Associate/Disassociate service profile module can be used by calling the ciscoucs_serviceprofile_association.pp and ciscoucs_serviceprofile_disassociation.pp, as 
shown in the example below:

######Associate service profile

```

transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}",
}

ciscoucs_serviceprofile_association { 'name':
  ensure                => "${ciscoucs_profile_association_disassociation['ensure_present']}",
  organization          => "${ciscoucs_profile_association_disassociation['organization']}",
  serviceprofile_name   => "${ciscoucs_profile_association_disassociation['serviceprofile_name']}",
  profile_dn            => "${ciscoucs_profile_association_disassociation['profile_dn']}",
  server_chassis_id     => "${ciscoucs_profile_association_disassociation['server_chassis_id']}",
  server_slot_id        => "${ciscoucs_profile_association_disassociation['server_slot_id']}",
  server_dn             => "${ciscoucs_profile_association_disassociation['server_dn']}",
  transport             => Transport_ciscoucs['ciscoucs'],
}

```
######Disassociate service profile

```

transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}",
}

ciscoucs_serviceprofile_association { 'name':
  ensure               => "${ciscoucs_profile_association_disassociation['ensure_absent']}",
  organization         => "${ciscoucs_profile_association_disassociation['organization']}",
  serviceprofile_name  => "${ciscoucs_profile_association_disassociation['serviceprofile_name']}",
  profile_dn           => "${ciscoucs_profile_association_disassociation['profile_dn']}",
  server_chassis_id    => "${ciscoucs_profile_association_disassociation['server_chassis_id']}",
  server_slot_id       => "${ciscoucs_profile_association_disassociation['server_slot_id']}",
  server_dn            => "${ciscoucs_profile_association_disassociation['server_dn']}",
  transport            => "${ciscoucs_profile_association_disassociation['transport']}",
}

```
###Power On / Power Off:

#####Power On 
   
The Power On method changes the power state from down to up for a service profile.  
   
#####Power Off

The Power off method changes the power state from up to down for a service profile.

####Summary of Parameters

#####Power On / Power Off:

1. serviceprofile_name: This parameter defines the name of the service profile.
    
2. organization: This parameter defines the source service profile path. A valid format is 'org-root'.
    
3. profile_dn: This pparameter defines the complete path of the source service profile including service profile name.
    
4. power_state: This parameter defines the initial state of the service profile that needs to be changed as follows:

       Up to change the initial state to On.
       Down to change the initial state to Off.
     
####Usage

The Power On / Power Off module can be used by calling the ciscoucs_power_on.pp and er_off.pp, as shown in the example below:

######Power On  

```
transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}",
}

ciscoucs_serviceprofile { 'serviceprofile_name':
  serviceprofile_name   => "${ciscoucs_serviceprofile['serviceprofile_name']}",
  organization          => "${ciscoucs_serviceprofile['organization']}",
  profile_dn            => "${ciscoucs_serviceprofile['profile_profile_dn']}",
  power_state           => "${ciscoucs_serviceprofile['power_state_on']}",
  transport             => Transport_ciscoucs['ciscoucs'],
}
```
######Power Off  

```
transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}",
}

ciscoucs_serviceprofile { 'serviceprofile_name':
  serviceprofile_name   => "${ciscoucs_serviceprofile['serviceprofile_name']}",
  organization          => "${ciscoucs_serviceprofile['organization']}",
  profile_dn            => "${ciscoucs_serviceprofile['profile_profile_dn']}",
  power_state           => "${ciscoucs_serviceprofile['power_state_off']}",
  transport             => Transport_ciscoucs['ciscoucs'],
}
```
###Boot Policy

Boot Policy determines how a server boots, specifying the boot devices, the method, and the boot order.The boot policy determines the following: 

    •	Configuration of the boot device 
    •	Location from which the server boots 
    •	Order in which boot devices are invoked 
    
The Boot policy must be included in a service profile, and that service profile must be associated with a server for it to take effect. If boot policy does not include in a service profile, the server uses the default settings in the BIOS to determine the boot order. 

### Modify service profile boot policy:

This method assigns an existing boot policy to the service profile. If a user selects this option, the Cisco UCS Manager displays the details of the policy.

####Summary of Parameters

#####Modify service profile boot policy:

1. bootpolicy_name: This parameter defines the name of the boot policy that is to be modified.

2. bootpolicy_organization: This parameter defines the source boot policy path. A valid format is 'org-root'.

3. ensure :   
        value: modify   
        
4. bootpolicy_dn: This parameter is a combination of the  bootpolicyorganization and the bootpolicyname. Either a user is required to provide the value of bootpolicydn or the values of bootpolicyorganization and bootpolicyname  as an input.

5. serviceprofile_name: This parameter describes the name of the service profile that is to be applied.

6. serviceprofile_organization: This parameter describes the source service profile path. A valid format is 'org-root'.
    
7. serviceprofile_dn: This parameter defines a combination of the serviceprofileorganization and serviceprofilename. Either a user is required to provide the value of the serviceprofiledn or the values of serviceprofileorganization and serviceprofilename as an input.
 
####Usage

The Modify service profile boot policy module can be used by calling the ciscoucs_serviceprofile_bootpolicy.pp, as shown in the example below:

######Modify service profile boot policy
```
transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}",
}

ciscoucs_serviceprofile_bootpolicy { 'serviceprofile_name':
  ensure                      => "${ciscoucs_serviceprofile_bootpolicy['ensure']}",
  transport                   => Transport_ciscoucs['ciscoucs'],
  bootpolicy_dn               => "${ciscoucs_serviceprofile_bootpolicy['bootpolicy_dn']}",
  bootpolicy_name             =>"${ciscoucs_serviceprofile_bootpolicy['bootpolicy_name']}",
  bootpolicy_organization     => "${ciscoucs_serviceprofile_bootpolicy['bootpolicy_organization']}",
  serviceprofile_dn           =>"${ciscoucs_serviceprofile_bootpolicy['serviceprofile_dn']}",
  serviceprofile_name         =>"${ciscoucs_serviceprofile_bootpolicy['serviceprofile_name']}",
  serviceprofile_organization => "${ciscoucs_serviceprofile_bootpolicy['serviceprofile_organization']}",
}
```
### Modify service profile boot order:
This method describes how to set the server boot order.

####Summary of Parameters

#####Modify service profile boot order:

1. bootpolicy_name: This parameter defines the name of the boot policy that is to be modified.

2. organization: This parameter defines the source boot policy path. A valid format is 'org-root'. 

3. bootpolicy_dn: This parameter defines the combination of bootpolicyorganization and bootpolicyname. Either a user is required to provide a value of the bootpolicydn or the values of the bootpolicyorganization and bootpolicyname as an input.
	
4. lan_order: This parameter defines the priority of LAN to boot a server within the available multiple boot options (such as SAN).  

####Usage

The Updatelan  boot order module can be used by calling the ciscoucs_serviceprofile_boot_order.pp, as shown in the example below:

######Modify service profile boot order:
```
transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}",
}

ciscoucs_serviceprofile_boot_order{ 'bootpolicy_name':
  ensure                => "${ciscoucs_serviceprofile_boot_order['ensure']}",
  transport             => Transport_ciscoucs['ciscoucs'],
  bootpolicy_dn         => "${ciscoucs_serviceprofile_boot_order['bootpolicy_dn']}",
  bootpolicy_name       =>"${ciscoucs_serviceprofile_boot_order['bootpolicy_name']}",
  organization          => "${ciscoucs_serviceprofile_boot_order['organization']}",
  lan_order             => "${ciscoucs_serviceprofile_boot_order['lan_order']}",
}
```
