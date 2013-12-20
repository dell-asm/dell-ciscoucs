include ciscoucs

transport { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '192.168.58.132',
}


ciscoucs_serviceprofile_association { 'name':
  organizationname => 'root',
  serviceprofilename => 'RameshNewSP',
  dnorganizationname => 'root',
  dnserviceprofilename => 'RameshNewSP',
  serverchesisid => 'chassis-1',
  serverslot => 'blade-3',
  ensure    => present,  
  transport  => Transport['ciscoucs'],
}

