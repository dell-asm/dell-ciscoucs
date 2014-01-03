include ciscoucs


import '../data.pp'

# providing wrong connection details to create service profile 

transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "",
  server   => "${ciscoucs['server']}",
 
}

ciscoucs_serviceprofile { 'name':
  name        => "${ciscoucs_serviceprofile['name']}",
  org         => "${ciscoucs_serviceprofile['org']}",
  dn         => "",
  server_chassis_id => "${ciscoucs_serviceprofile['server_chassis_id']}",
  server_slot => "${ciscoucs_serviceprofile['server_slot']}",
  ensure          => "${ciscoucs_serviceprofile['ensure']}",
  transport   => Transport_ciscoucs['ciscoucs'],
}