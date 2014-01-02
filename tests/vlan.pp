include ciscoucs
transport_ciscoucs { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '10.2.0.66',
}

ciscoucs_vlan { 'testvlan':
  ensure    		=> present,
  transport 		=> Transport_ciscoucs['ciscoucs'],
  id        		=> '10',
  mcast_policy_name => '',
  sharing	        => 'primary',
  fabric_id         => 'B',
  status            => 'created',
}
