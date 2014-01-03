include ciscoucs

import '../data.pp'

# providing invalid input parameters (more than 33 charater) to create service profile 

transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}",
 
}

ciscoucs_serviceprofile { 'name':
  name        => "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKL",
  org         => "${ciscoucs_serviceprofile['org']}",
  dn         => "",
  server_chassis_id => "${ciscoucs_serviceprofile['server_chassis_id']}",
  server_slot => "${ciscoucs_serviceprofile['server_slot']}",
  ensure          => "${ciscoucs_serviceprofile['ensure']}",
  transport   => Transport_ciscoucs['ciscoucs'],
}