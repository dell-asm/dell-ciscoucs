include ciscoucs

import '../data.pp'

# Power On Service Profile operation - for profile created from existing server
transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}",
 
}

ciscoucs_serviceprofile { 'name':
  name        => "",
  org         => "",
  dn         => "${ciscoucs_serviceprofile['dn']}",
  power_state => "${ciscoucs_serviceprofile['power_state_on']}",
  transport   => Transport_ciscoucs['ciscoucs'],
}