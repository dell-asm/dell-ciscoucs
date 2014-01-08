include ciscoucs

import '../data.pp'

# Power On Service Profile operation -when organization and serviceprofile_name is provided.

transport_ciscoucs { 'ciscoucs':
  username => "ddd",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}",
 
}

ciscoucs_serviceprofile { 'serviceprofile_name':
  serviceprofile_name        => "${ciscoucs_serviceprofile['serviceprofile_name']}",
  organization         => "${ciscoucs_serviceprofile['organization']}",
  #profile_dn         => "",
  power_state => "${ciscoucs_serviceprofile['power_state_on']}",
  transport   => Transport_ciscoucs['ciscoucs'],
}

