include ciscoucs

transport_ciscoucs { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '192.168.114.131',
}

ciscoucs_modify_serviceprofile_boot_policy { 'serviceprofilename':
   ensure    => "${ciscoucs_modify_boot_policy['ensure']}",
   transport  => Transport_ciscoucs['ciscoucs'],
   bootpolicydn => "${ciscoucs_modify_boot_policy['bootpolicydn']}",
   bootpolicyname =>"${ciscoucs_modify_boot_policy['bootpolicyname']}",
   bootpolicyorganization => "${ciscoucs_modify_boot_policy['bootpolicyorganization']}",
   serviceprofiledn =>"${ciscoucs_modify_boot_policy['serviceprofiledn']}",
   serviceprofilename =>"${ciscoucs_modify_boot_policy['serviceprofilename']}",
   serviceprofileorganization => "${ciscoucs_modify_boot_policy['serviceprofileorganization']}",
}