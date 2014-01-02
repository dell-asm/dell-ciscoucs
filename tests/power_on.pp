include ciscoucs

import 'data.pp'

transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}",
 
}

ciscoucs_serviceprofile { 'name':
  name        => "${ciscoucs_serviceprofile['name']}",
  org         => "${ciscoucs_serviceprofile['org']}",
  dn         => "${ciscoucs_serviceprofile['dn']}",
  power_state => "${ciscoucs_serviceprofile['power_state']}",
  transport   => Transport_ciscoucs['ciscoucs'],
}