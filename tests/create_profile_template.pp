include ciscoucs

transport_ciscoucs { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '192.168.24.130',
}


ciscoucs_serviceprofile { 'name':
  name            => 'create_prof',
  org             => 'org-root',
  ensure          => present,
  source_template => 'test_temp',
  #power_state    => 'up',
  transport       => Transport_ciscoucs['ciscoucs'],
}

