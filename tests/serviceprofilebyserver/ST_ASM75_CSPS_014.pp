include ciscoucs

transport_ciscoucs { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '192.168.241.131',
}

# Providing wrong server slot to create Service Profile 

ciscoucs_serviceprofile { 'name':
  name            => 'SP1',
  org             => 'org-root',
  dn              => ''
  ensure          => present,
  server_chassis_id => 'chassis-1',
  server_slot => 'blade-1001',   
  transport       => Transport_ciscoucs['ciscoucs'],
}

