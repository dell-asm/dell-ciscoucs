include ciscoucs

transport_ciscoucs { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '192.168.199.131',
}


ciscoucs_updatelan_boot_order{ 'dn':
  
  policyname => 'org-root/boot-policy-testbootpolicy',
  lanorder =>'3',
  transport  => Transport_ciscoucs['ciscoucs'],
}

