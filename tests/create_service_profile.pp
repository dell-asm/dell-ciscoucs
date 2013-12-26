include ciscoucs

transport { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '192.168.247.132',
}


create_server_profile_from_template { 'name':
  name 	  => 'test_profile',
  ensure    => present,
  transport  => Transport['ciscoucs'],
  agentpolicyname               => 'aa',
  biosprofilename		=> '',  
  bootpolicyname                => '',
  descr 	                => 'test_profile',
  dn				=> 'org-root/ls-test_profile',
  dynamicconpolicyname 		=> '',
  extippoolname 	        => 'ext-mgmt',
  extipstate	                => 'none',
  hostfwpolicyname              => '',
  identpoolname			=> '',  
  localdiskpolicyname           => '',
  maintpolicyname 	        => '',
  mgmtaccesspolicyname	        => '',
  mgmtfwpolicyname 		=> '',
  policyowner	                => 'local',
  powerpolicyname               => 'default',
  scrubpolicyname		=> '',  
  solpolicyname                 => '',
  srctemplname 	                => 'test',
  statspolicyname	        => 'default',
  status 			=> 'created',
  usrlbl 	                => '',
  uuid	                        => '0',
  vconprofilename               => '',
}

