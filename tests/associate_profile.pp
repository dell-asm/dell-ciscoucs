include ciscoucs

transport { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '192.168.145.130',
}


ciscoucs_serviceprofile_association { 'name':
  ensure    => present, 
  organizationname => 'root',
  serviceprofilename => 'DemoTestServiceProfile',
  dnorganizationname => 'root',
  dnserviceprofilename => 'DemoTestServiceProfile',
  serverchesisid => 'chassis-1',
  serverslot => 'blade-3',   
  transport  => Transport['ciscoucs'],
}

