include ciscoucs

transport_ciscoucs { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '',
}


ciscoucs_serviceprofile { 'name':
   name        => 'testServiceProfile',
  org         => 'org-root',
  dn          => '',
  #ensure      => present,
  power_state => 'up',
  transport   => Transport_ciscoucs['ciscoucs'],
}

