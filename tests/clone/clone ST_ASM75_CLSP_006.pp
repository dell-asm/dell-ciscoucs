include ciscoucs

transport_ciscoucs { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '192.168.40.131',
}

# providing Single character as an input  

ciscoucs_serviceprofile_clone { 'sourceprofilename':
   ensure    => present,
   transport  => Transport_ciscoucs['ciscoucs'],
   sourceprofiledn => 'org-root/org-Finance/testing',
   targetprofiledn => '', 
   sourceserviceprofilename      => '',
   sourceorganization => '',
    targetserviceprofilename      => 'A',
   targetorganization => 'org-root/org-Finance/org-test1/org-test2',
}
