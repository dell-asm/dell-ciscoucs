include ciscoucs

import '../data.pp'

# As a user I want to see proper error message when user enters invalid value(name suffix "9999999990") in input and executes the operation.

transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}",
 
}


ciscoucs_serviceprofile { 'name':
  name        => "9999999990",
  org         => "${ciscoucs_serviceprofile['org']}",
  dn         => "",
  ensure  => "${ciscoucs_serviceprofile['ensure']}",
  source_template => "${ciscoucs_serviceprofile['source_template']}",
  transport   => Transport_ciscoucs['ciscoucs'],
}
