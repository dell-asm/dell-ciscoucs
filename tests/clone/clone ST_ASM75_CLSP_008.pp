include ciscoucs

transport_ciscoucs { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '192.168.40.131',
}

# providing Invalid input string (more than 33 characters) 

ciscoucs_serviceprofile_clone { 'sourceprofilename':
   ensure    => present,
   transport  => Transport_ciscoucs['ciscoucs'],
   sourceprofiledn => 'org-root/org-Finance/testing',
   targetprofiledn => '', 
   sourceserviceprofilename      => '',
   sourceorganization => '',
   targetserviceprofilename      => 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJK',
   targetorganization => 'org-root/org-Finance/org-test1/org-test2',
}
