

$ciscoucs = {
  'username' => 'admin',
  'password' =>  'admin',
  'server'   => '192.168.40.131',  
}


$ciscoucs_serviceprofile = { 
  'name'        => 'testServiceProfile',
  'org'         => 'org-root',
  'dn'        => '',
  'power_state_on' => 'up',
  'power_state_off' => 'down',
  'ensure'          => 'present',
  'source_template' => 'testing',
  'server_chassis_id' => 'chassis-1',
  'server_slot' => 'blade-1',  
  'number_of_profiles' => '1', 
}


$ciscoucs_clone = { 
   'ensure'    => 'present',
   'sourceprofiledn' => '',
   'targetprofiledn' => '', 
   'sourceserviceprofilename'      => 'testServiceProfile',
   'sourceorganization' => 'org-root',
   'targetserviceprofilename'      => 'testclone',
   'targetorganization' => 'org-root/org-Finance/org-test1',
}

$ciscoucs_modify_boot_policy = { 
   'ensure'    => 'modify',
   'bootpolicydn' => 'org-root/boot-policy-testbootpolicy',
   'bootpolicyname' => 'testbootpolicy',
   'bootpolicyorganization' => 'org-root',
   'serviceprofiledn' => 'org-root/ls-template1',
   'serviceprofilename' => 'template1',
   'serviceprofileorganization' => 'org-root',

}


$ciscoucs_profile_association_dissociation = {
  ensure_present    => present, 
  ensure_absent    => absent, 
  organization_name => 'org-root',
  service_profile_name => 'testing',
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



