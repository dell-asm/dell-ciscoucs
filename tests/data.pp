

$ciscoucs = {
  'username' => 'admin',
  'password' =>  'admin',
  'server'   => '192.168.199.131',  
}


$ciscoucs_serviceprofile = { 
'serviceprofile_name' => 'testServiceProfile',
'organization' => 'org-root',
'profile_dn' => '',
'power_state_on' => 'up',
'power_state_off' => 'down',
'ensure' => 'present',
'source_template' => 'testing',
'server_chassis_id' => 'chassis-1',
'server_slot' => 'blade-1', 
'number_of_profiles' => '1', 
}




$ciscoucs_serviceprofile_clone = { 
   'ensure'=> 'present',
   'source_profile_dn'=> 'org-root/ls-test',
   'target_profile_dn'=> 'org-root/ls-testclone', 
   'source_serviceprofile_name'=> 'test',
   'source_organization'=> 'org-root',
   'target_serviceprofile_name' => 'testclone',
   'target_organization'    => 'org-root',
}


$ciscoucs_serviceprofile_bootpolicy = { 
   'ensure'=> 'modify',
   'bootpolicy_dn'=> 'org-root/boot-policy-testbootpolicy',
   'bootpolicy_name'=> 'testbootpolicy',
   'bootpolicy_organization'=> 'org-root',
   'serviceprofile_dn'=> 'org-root/ls-abc',
   'serviceprofile_name'=> 'abc',
   'serviceprofile_organization' => 'org-root',

}

$ciscoucs_profile_association_disassociation = {
  ensure_present    => present, 
  ensure_absent    => absent, 
  organization => 'org-root',
  serviceprofile_name => 'testing',
  profile_dn => '',
  server_chassis_id => 'chassis-1',
  server_slot_id => 'blade-3',   
  server_dn => '',
  transport  => Transport_ciscoucs['ciscoucs'],

}

$ciscoucs_serviceprofile_boot_order= { 
   'ensure'    => 'present',
   'dn' => 'org-root/boot-policy-testbootpolicy',
   'bootpolicy_name' => 'testbootpolicy',
   'organization' => 'org-root',
   'lan_order' => '5',
}



