include ciscoucs

transport { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '192.168.24.130',
}


ciscoucs_serverprofile { 'name':
   name => 'test_123', 
  ensure    => present,
  transport  => Transport['ciscoucs'],
}

