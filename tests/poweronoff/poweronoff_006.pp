include ciscoucs


# Power Off Service Profile  - for profile created from existing server

import '../data.pp'

transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}",
 
}

ciscoucs_serviceprofile { 'name':
  name        => "${ciscoucs_serviceprofile['name']}",
  org         => "${ciscoucs_serviceprofile['org']}",
  dn         => "${ciscoucs_serviceprofile['dn']}",
  power_state => "${ciscoucs_serviceprofile['power_state_off']}",
  transport   => Transport_ciscoucs['ciscoucs'],
}
