include ciscoucs

transport_ciscoucs { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '192.168.24.130',
}


ciscoucs_serviceprofile { 'name':
   name => 'test_123', 
  ensure    => present,
  transport  => Transport_ciscoucs['ciscoucs'],
}

