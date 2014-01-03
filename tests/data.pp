

$ciscoucs = {
  'username' => 'admin',
  'password' =>  'admin',
  'server'   => '192.168.40.131',  
}


$ciscoucs_serviceprofile = { 
  'name'        => 'abhijServiceProfile',
  'org'         => 'org-root',
  'dn'        => '',
  'power_state_on' => 'up',
  'power_state_off' => 'down',
  'ensure'          => 'present',
  'source_template' => 'testing',
  'server_chassis_id' => 'chassis-1',
  'server_slot' => 'blade-1',   
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

$ciscoucs_modify_serviceprofile_boot_policy = { 
   'ensure'    => 'modify',
   'transport'  => Transport_ciscoucs['ciscoucs'],
   'bootpolicydn' => 'org-root/boot-policy-test_boot_policy',
   'bootpolicyname' => 'test_boot_policy',
   'bootpolicyorganization' => 'org-root',
   'serviceprofiledn' => 'org-root/ls-testing',
   'serviceprofilename' => 'testing',
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
>>>>>>> .r6306
}