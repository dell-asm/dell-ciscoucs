include ciscoucs

transport_ciscoucs { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '192.168.199.131',
}


ciscoucs_updatelan_boot_order{ 'dn':
  
  value => 'org-root/boot-policy-testbootpolicy',
  lanorder =>'4',
  #  value => 'testbootpolicy',
  transport  => Transport_ciscoucs['ciscoucs'],
}

