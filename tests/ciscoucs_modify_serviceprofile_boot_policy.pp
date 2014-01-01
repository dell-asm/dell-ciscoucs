include ciscoucs

transport_ciscoucs { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '192.168.40.131',
}

ciscoucs_modify_serviceprofile_boot_policy { 'serviceprofilename':
   ensure    => present,
   transport  => Transport_ciscoucs['ciscoucs'],
   bootpolicydn => 'org-root/boot-policy-test_boot_policy',
   bootpolicyname => 'test_boot_policy',
   bootpolicyorganization => 'org-root',
   serviceprofiledn => 'org-root/ls-testing',
   serviceprofilename => 'testing',
   serviceprofileorganization => 'org-root',
}