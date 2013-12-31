include ciscoucs
transport_ciscoucs { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '10.2.0.66',
}

ciscoucs_create_vlan { 'testvlan':
  ensure    		=> present,
  transport 		=> Transport_ciscoucs['ciscoucs'],
  id        		=> '10',
  mcast_policy_name => '',
  sharing	        => '',
  fabric_id         => '',
  status            => 'created',
}
