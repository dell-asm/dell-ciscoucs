include ciscoucs

import '../data.pp'

# Error message when executing power off for already powered off server profile created from template.

transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}",
 
}

ciscoucs_serviceprofile { 'name':
  name        => "${ciscoucs_serviceprofile['name']}",
  org         => "${ciscoucs_serviceprofile['org']}",
  dn         => "",
  power_state => "${ciscoucs_serviceprofile['power_state_off']}",
  transport   => Transport_ciscoucs['ciscoucs'],
}