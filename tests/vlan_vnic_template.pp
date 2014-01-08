include ciscoucs
transport_ciscoucs { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '172.16.103.176',
}

ciscoucs_vlan_vnic_template { 'Test1234':
  vnictemplateorg => 'org-root',
  vlanname 	  => 'test123456',
  defaultnet   => 'no',
  ensure    => present,
  transport => Transport_ciscoucs['ciscoucs'],
}

