include ciscoucs

transport_ciscoucs { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '192.168.40.131',
}

# creating Service Profile which is already present. 

ciscoucs_serviceprofile_clone { 'sourceprofilename':
   ensure    => present,
   transport  => Transport_ciscoucs['ciscoucs'],
   sourceprofiledn => '',
   targetprofiledn => '', 
   sourceserviceprofilename      => 'testing',
   sourceorganization => 'org-root/org-Finance',
   targetserviceprofilename      => 'testing',
   targetorganization => 'org-root/org-Finance',
}
