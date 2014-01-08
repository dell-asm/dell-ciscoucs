include ciscoucs

transport_ciscoucs { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '192.168.199.131',
}


ciscoucs_serviceprofile_boot_order{ 'dn':  
  bootpolicy_name => 'testbootpolicy',
  organization   => 'org-root',
  lan_order       =>'1',
  transport      => Transport_ciscoucs['ciscoucs'],
  ensure         => 'present',
}

