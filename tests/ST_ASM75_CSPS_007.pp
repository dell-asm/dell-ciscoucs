include ciscoucs

transport_ciscoucs { 'ciscoucs':
  username => 'admin',
  password => 'admin', 
  server   => '192.168.241.131',
}

# providing invalid input parameters (more than 33 charater) to create service profile 

ciscoucs_serviceprofile { 'name':
  name            => 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKL',
  org             => 'org-root',
  dn              => ''
  ensure          => present,
  server_chassis_id => 'chassis-1',
  server_slot => 'blade-1',   
  transport       => Transport_ciscoucs['ciscoucs'],
}

