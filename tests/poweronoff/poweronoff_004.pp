include ciscoucs

# Power On Service Profile operation - for profile associated to a server

import '../data.pp'

transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}",
 
}

ciscoucs_serviceprofile { 'name':
  name        => "${ciscoucs_serviceprofile['name']}",
  org         => "${ciscoucs_serviceprofile['org']}",
  dn         => "",
  power_state => "${ciscoucs_serviceprofile['power_state_on']}",
  transport   => Transport_ciscoucs['ciscoucs'],
}