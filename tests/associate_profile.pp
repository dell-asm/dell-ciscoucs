include ciscoucs

transport_ciscoucs { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '192.168.145.130',
}


ciscoucs_serviceprofile_association { 'name':
  ensure    => present, 
  organization_name => 'root',
  service_profile_name => 'DemoTestServiceProfile',
  profile_dn => '',
  server_chassis_id => 'chassis-1',
  server_slot_id => 'blade-3',   
  server_dn => '',
  transport  => Transport_ciscoucs['ciscoucs'],
}

