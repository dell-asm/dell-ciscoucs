include ciscoucs

transport_ciscoucs { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '192.168.40.131',
}

# providing Invalid organization name as an input  

ciscoucs_serviceprofile_clone { 'sourceprofilename':
   ensure    => present,
   transport  => Transport_ciscoucs['ciscoucs'],
   sourceprofiledn => '',
   targetprofiledn => '', 
   sourceserviceprofilename      => 'testing',
   sourceorganization => 'org-root/org-dummy',
   targetserviceprofilename      => 'clone',
   targetorganization => 'org-root/org-Finance/org-test1/org-test2',
}
