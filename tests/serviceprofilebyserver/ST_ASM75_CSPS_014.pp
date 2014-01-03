include ciscoucs


import '../data.pp'

# Providing wrong server slot to create Service Profile 

transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}",
 
}

ciscoucs_serviceprofile { 'name':
  name        => "${ciscoucs_serviceprofile['name']}",
  org         => "${ciscoucs_serviceprofile['org']}",
  dn         => "",
  server_chassis_id => "${ciscoucs_serviceprofile['server_chassis_id']}",
  server_slot => "blade-1001",
  ensure          => "${ciscoucs_serviceprofile['ensure']}",
  transport   => Transport_ciscoucs['ciscoucs'],
}
