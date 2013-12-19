include ciscoucs

transport { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '192.168.58.132',
}


ciscoucs_serviceprofile_associate { 'name':
  organization_name => 'root',
  service_profile_name => 'RameshNewSP',
  dn_organization_name => 'root',
  dn_service_profile_name => 'RameshNewSP',
  server_chesis_id => 'chassis-1',
  server_slot => 'blade-3',
  ensure    => present,  
  transport  => Transport['ciscoucs'],
}

