include ciscoucs

transport_ciscoucs { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '10.2.0.66',
}


create_vlan { 'testvlan':
  ensure    => present,
  transport  => Transport_ciscoucs['ciscoucs'],
  id                => '10',
  mcast_policy_name   => '',
  policy_owner 		=> 'local',
  sharing	        => 'none',
  status 			=> 'created',
 }
