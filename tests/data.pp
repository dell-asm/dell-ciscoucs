

$ciscoucs = {
  'testcase' => '001',
  'username' => 'admin',
  'password' =>  'admin',
  'server'   => '192.168.114.131',  
}


$ciscoucs_serviceprofile = { 
  'name'        => 'abhijServiceProfile',
  'org'         => 'org-root',
  'dn'        => '',
  'power_state_on' => 'up',
  'power_state_off' => 'down',
  'ensure'          => 'present',
  'source_template' => 'template1',
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
