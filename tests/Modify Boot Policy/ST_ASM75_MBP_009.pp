include ciscoucs

import '../data.pp'

transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}",
 
}


ciscoucs_modify_serviceprofile_boot_policy { 'serviceprofilename':
   ensure    => "${ciscoucs_modify_serviceprofile_boot_policy['ensure']}",,
   transport  => Transport_ciscoucs['ciscoucs'],
   bootpolicydn => "",
   bootpolicyname => "{ciscoucs_modify_serviceprofile_boot_policy['bootpolicyname']}",
   bootpolicyorganization => "{ciscoucs_modify_serviceprofile_boot_policy['bootpolicyorganization']}",
   serviceprofiledn => "",
   serviceprofilename => "$$$$$",
   serviceprofileorganization => "{ciscoucs_modify_serviceprofile_boot_policy['serviceprofileorganization']}",
}
