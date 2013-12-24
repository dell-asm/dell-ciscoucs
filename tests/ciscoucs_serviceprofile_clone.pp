include ciscoucs

transport_ciscoucs { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '192.168.40.131',
}

ciscoucs_serviceprofile_clone { 'clonename':
   clonename => 'clone_2', 
   ensure    => present,
   transport  => Transport_ciscoucs['ciscoucs'],
   sourceserviceprofile      => 'org-root/org-Finance/ls-testing',
   targetorganizationname => 'org-root/org-Finance',
}

