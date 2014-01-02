include ciscoucs

import 'data.pp'

transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}", 
}

ciscoucs_modify_serviceprofile_boot_policy {"${ciscoucs_serviceprofile_boot_policy['serviceprofilename']}":
   ensure    => "${ciscoucs_serviceprofile_boot_policy['ensure']}",
   transport  => "${ciscoucs_serviceprofile_boot_policy['transport']}",
   bootpolicydn => "${ciscoucs_serviceprofile_boot_policy['bootpolicydn']}",
   bootpolicyname => "${ciscoucs_serviceprofile_boot_policy['bootpolicyname']}",
   bootpolicyorganization => "${ciscoucs_serviceprofile_boot_policy['bootpolicyorganization']}",
   serviceprofiledn => "${ciscoucs_serviceprofile_boot_policy['serviceprofiledn']}",
   serviceprofilename => "${ciscoucs_serviceprofile_boot_policy['serviceprofilename']}",
   serviceprofileorganization => "${ciscoucs_serviceprofile_boot_policy['serviceprofileorganization']}",
}