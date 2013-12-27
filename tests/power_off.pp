include ciscoucs

transport_ciscoucs { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '192.168.24.130',
}


ciscoucs_serviceprofile { 'name':
  name        => 'test_123',
  org         => 'org-root',
  #ensure      => present,
  power_state => 'down',
  transport   => Transport_ciscoucs['ciscoucs'],
}

