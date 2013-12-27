include ciscoucs

transport_ciscoucs { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '192.168.40.131',
}

ciscoucs_serviceprofile_clone { 'sourceprofilename':
   sourceprofilename => '', 
   ensure    => present,
   transport  => Transport_ciscoucs['ciscoucs'],
   sourceserviceprofile      => 'testing',
   sourceorganization => 'org-root/org-Finance',
   targetprofilename => '', 
   targetrviceprofile      => 'clone10',
   targetorganization => 'org-root/org-Finance',
}
