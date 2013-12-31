include ciscoucs

# providing wrong connection details to create service profile 

transport_ciscoucs { 'ciscoucs':
  username => 'admin',
  password => 'P@ssworD',
  server   => '192.168.241.131',
}

ciscoucs_serviceprofile { 'name':
  name            => 'SP1',
  org             => 'org-root',
  dn              => ''
  ensure          => present,
  server_chassis_id => 'chassis-1',
  server_slot => 'blade-1',   
  transport       => Transport_ciscoucs['ciscoucs'],
}

