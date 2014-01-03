include ciscoucs

import '../data.pp'

# As a user I want to see proper success message when user enters blank value(Profile DN) in input and executes the operation.

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
