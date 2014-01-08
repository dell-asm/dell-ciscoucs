include ciscoucs

import '../data.pp'

transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}",
 
}

ciscoucs_serviceprofile { 'serviceprofile_name':
  #serviceprofile_name        => "${ciscoucs_serviceprofile['serviceprofile_name']}",
  #organization         => "${ciscoucs_serviceprofile['organization']}",
  profile_dn         => "####",
  power_state => "${ciscoucs_serviceprofile['power_state_off']}",
  transport   => Transport_ciscoucs['ciscoucs'],
}