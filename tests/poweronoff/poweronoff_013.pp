include ciscoucs

import '../data.pp'

# As a user I want to see proper error message when user enters invalid value(UCS Connection Information) in input and executes the operation.

transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "",
 
}

ciscoucs_serviceprofile { 'name':
  name        => "",
  org         => "",
  dn         => "${ciscoucs_serviceprofile['dn']}",
  power_state => "${ciscoucs_serviceprofile['power_state_on']}",
  transport   => Transport_ciscoucs['ciscoucs'],
}
