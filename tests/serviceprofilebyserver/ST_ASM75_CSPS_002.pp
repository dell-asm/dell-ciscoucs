include ciscoucs

transport_ciscoucs { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '192.168.241.131',
}

# create hardware based service profile in different organisation  

ciscoucs_serviceprofile { 'name':
  name            => 'SP1',
  org             => 'org-root/org-Finance',
  dn              => ''
  ensure          => present,
  server_chassis_id => 'chassis-1',
  server_slot => 'blade-1',   
  transport       => Transport_ciscoucs['ciscoucs'],
}

