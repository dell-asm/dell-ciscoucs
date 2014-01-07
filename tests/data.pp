

$ciscoucs = {
  'username' => 'admin',
  'password' =>  'admin',
  'server'   => '192.168.241.131',  
}


$ciscoucs_serviceprofile = { 
  'serviceprofile_name'        => 'testServiceProfile',
  'organization'         => 'org-root',
  'profile_dn'        => '',
  'power_state_on' => 'up',
  'power_state_off' => 'down',
  'ensure'          => 'present',
  'source_template' => 'testing',
  'server_chassis_id' => 'chassis-1',
  'server_slot' => 'blade-1',  
  'number_of_profiles' => '1', 
}


$ciscoucs_serviceprofile_clone = { 
   'ensure'=> 'present',
   'sourceprofiledn'=> 'org-root/ls-SP1',
   'targetprofiledn'=> 'org-root/ls-gk1', 
   'sourceserviceprofilename'=> 'SP1',
   'sourceorganization'=> 'org-root',
   'targetserviceprofilename' => 'testclone',
   'targetorganization'    => 'org-root',
}


$ciscoucs_modify_serviceprofile_boot_policy = { 
   'ensure'=> 'modify',
   'bootpolicydn'=> 'org-root/boot-policy-testbootpolicy',
   'bootpolicyname'=> 'gk',
   'bootpolicyorganization'=> 'org-root/org-gk',
   'serviceprofiledn'=> 'org-root/ls-SP1',
   'serviceprofilename'=> 'SP1',
   'serviceprofileorganization' => 'org-root',

}

$ciscoucs_profile_association_dissociation = {
  ensure_present    => present, 
  ensure_absent    => absent, 
  organization_name => 'org-root',
  service_profile_name => 'SP1',
  profile_dn => '',
  server_chassis_id => 'chassis-1',
  server_slot_id => 'blade-3',   
  server_dn => '',
  transport  => Transport_ciscoucs['ciscoucs'],

}

$ciscoucs_modify_lan_bootorder= { 
   'ensure'    => 'present',
   'dn' => 'org-root/boot-policy-test_boot_policy',
   'bootpolicyname' => 'test_boot_policy',
   'organization' => 'org-root',
   'lanorder' => '2',
}



