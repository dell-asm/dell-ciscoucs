include ciscoucs

transport_ciscoucs { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '192.168.40.131',
}

# providing same clone name with different targetorganization 

ciscoucs_serviceprofile_clone { 'sourceprofilename':
   ensure    => present,
   transport  => Transport_ciscoucs['ciscoucs'],
   sourceprofiledn => 'org-root/org-Finance/testing',
   targetprofiledn => '', 
   sourceserviceprofilename      => '',
   sourceorganization => '',
   targetserviceprofilename      => 'clone',
   targetorganization => 'org-root/',
}
