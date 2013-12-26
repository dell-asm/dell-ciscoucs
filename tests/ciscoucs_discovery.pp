include ciscoucs

transport_ciscoucs { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '192.168.241.131',
}


ciscoucs_discovery { 'name':
  ensure    => absent,   
  transport  => Transport_ciscoucs['ciscoucs'],
}

