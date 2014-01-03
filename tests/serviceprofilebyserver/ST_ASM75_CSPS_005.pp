include ciscoucs


import '../data.pp'

# providing invalid input parameters (special charaters) to create service profile 

transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}",
 
}

ciscoucs_serviceprofile { 'name':
  name        => "${ciscoucs_serviceprofile['name']}",
  org         => "org-r@@t",
  dn         => "",
  server_chassis_id => "${ciscoucs_serviceprofile['server_chassis_id']}",
  server_slot => "${ciscoucs_serviceprofile['server_slot']}",
  ensure          => "${ciscoucs_serviceprofile['ensure']}",
  transport   => Transport_ciscoucs['ciscoucs'],
}

