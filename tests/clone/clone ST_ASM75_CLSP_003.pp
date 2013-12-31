include ciscoucs

transport_ciscoucs { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '192.168.40.131',
}

# providing only Targetprofiledn 

ciscoucs_serviceprofile_clone { 'sourceprofilename':
   ensure    => present,
   transport  => Transport_ciscoucs['ciscoucs'],
   sourceprofiledn => '',
   targetprofiledn => 'org-root/org-Finance/org-test1/org-test2/clone', 
   sourceserviceprofilename      => 'testing',
   sourceorganization => 'org-root/org-Finance',
   targetserviceprofilename      => '',
   targetorganization => '',
}
