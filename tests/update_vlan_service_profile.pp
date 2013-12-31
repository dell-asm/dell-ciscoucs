include ciscoucs
transport_ciscoucs { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '172.16.103.176',
}

ciscoucs_update_vlan_service_profile { 'test1231':
  serviceprofileorg => 'org-root',
  vlanname 	  => 'test12345678',
  defaultnet   => 'no',
  vnic      => 'eth0',
  ensure    => present,
  transport => Transport_ciscoucs['ciscoucs'],
}

