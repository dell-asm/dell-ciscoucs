include ciscoucs

transport_ciscoucs { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '192.168.24.130',
}


ciscoucs_modify_lan_bootorder{ 'dn':  
  bootpolicyname => 'testbootpolicy',
  organization   => 'org-root',
  lanorder       =>'2',
  transport      => Transport_ciscoucs['ciscoucs'],
  ensure         => 'present',
}

