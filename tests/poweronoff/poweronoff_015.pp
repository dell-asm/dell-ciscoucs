include ciscoucs

import '../data.pp'

# As a user I want to see proper error message when user enters invalid value in Profile Name.

transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}",
 
}

ciscoucs_serviceprofile { 'name':
  name        => "",
  org         => "${ciscoucs_serviceprofile['org']}",
  dn         => "",
  power_state => "${ciscoucs_serviceprofile['power_state_on']}",
  transport   => Transport_ciscoucs['ciscoucs'],
}