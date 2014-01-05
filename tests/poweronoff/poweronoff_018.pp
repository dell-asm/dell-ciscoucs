include ciscoucs

import '../data.pp'

transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}",
 
}

ciscoucs_serviceprofile { 'name':
  name        => "####",
  org         => "${ciscoucs_serviceprofile['org']}",
  #dn         => "orrt",
  power_state => "${ciscoucs_serviceprofile['power_state_off']}",
  transport   => Transport_ciscoucs['ciscoucs'],
}