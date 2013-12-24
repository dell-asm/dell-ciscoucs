include ciscoucs

transport_ciscoucs { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '192.168.145.130',
}


ciscoucs_serviceprofile_association { 'name':
  ensure    => absent, 
  organizationname => 'root',
  serviceprofilename => 'DemoTestServiceProfile',
  dnorganizationname => 'root',
  dnserviceprofilename => 'DemoTestServiceProfile',
  serverchesisid => 'chassis-1',
  serverslot => 'blade-3',   
  transport  => Transport_ciscoucs['ciscoucs'],
}

