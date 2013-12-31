include ciscoucs

transport_ciscoucs { 'ciscoucs':
  username => 'admin',
  password => 'admin', 
  server   => '192.168.241.131',
}

# providing dn to create service profile 

ciscoucs_serviceprofile { 'name':
  name            => '',
  org             => '',
  dn              => 'org-root/TestSP'
  ensure          => present,
  server_chassis_id => 'chassis-1',
  server_slot => 'blade-1',   
  transport       => Transport_ciscoucs['ciscoucs'],
}

