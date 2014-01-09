include ciscoucs
transport_ciscoucs { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '172.16.103.176',
}

ciscoucs_vlan_serviceprofile { 'test1231':
  serviceprofileorg => 'org-root',
  vlan_name 	  => 'test12345678',
  defaultnet   => 'no',
  vnic      => 'eth0',
  ensure    => present,
  transport => Transport_ciscoucs['ciscoucs'],
}

