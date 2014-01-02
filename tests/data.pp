

$ciscoucs = {
  'username' => 'admin',
  'password' =>  'admin',
  'server'   => '192.168.114.131',
  
}


$ciscoucs_poweronoff = { 
  'name'        => 'testServiceProfile',
  'org'         => 'org-root',
  'dn'        => '',
  'power_state' => 'up',
 
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