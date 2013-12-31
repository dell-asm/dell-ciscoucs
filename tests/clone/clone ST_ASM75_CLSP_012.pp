#Provide Invalid connection details

include ciscoucs

transport_ciscoucs { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '192.168.40.000',
}

ciscoucs_serviceprofile_clone { 'sourceprofilename':
   ensure    => present,
   transport  => Transport_ciscoucs['ciscoucs'],
   sourceprofiledn => 'org-root/org-Finance/testing',
   targetprofiledn => '', 
   sourceserviceprofilename      => '',
   sourceorganization => '',
   targetserviceprofilename      => 'clone',
   targetorganization => 'org-root/org-Finance/org-test1/org-test2',
}
