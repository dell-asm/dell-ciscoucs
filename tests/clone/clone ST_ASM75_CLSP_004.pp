include ciscoucs

transport_ciscoucs { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '192.168.40.13                                                                                                                                          1',
}

# providing Sourceprofiledn and Targetprofiledn 

ciscoucs_serviceprofile_clone { 'sourceprofilename':
   ensure    => present,
   transport  => Transport_ciscoucs['ciscoucs'],
   sourceprofiledn => 'org-root/org-Finance/testing',
   targetprofiledn => 'org-root/org-Finance/org-test1/org-test2/clone', 
   sourceserviceprofilename      => '',
   sourceorganization => '',
   targetserviceprofilename      => '',
   targetorganization => '',
}
     