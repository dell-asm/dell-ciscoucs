include ciscoucs
import '../data.pp'

transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}",
 
}

ciscoucs_modify_serviceprofile_boot_policy{'serviceprofiledn': 
  #serviceprofiledn =>"${ciscoucs_modify_serviceprofile_boot_policy['serviceprofiledn']}",
  transport      => Transport_ciscoucs['ciscoucs'],
  ensure         => "${ciscoucs_modify_serviceprofile_boot_policy['ensure']}",
  #bootpolicydn   => "${ciscoucs_modify_serviceprofile_boot_policy['bootpolicydn']}",
  
   bootpolicyname => "${ciscoucs_modify_serviceprofile_boot_policy['bootpolicyname']}",
   bootpolicyorganization => "${ciscoucs_modify_serviceprofile_boot_policy['bootpolicyorganization']}",
   
   serviceprofilename => "cccccccccccccccccc",
   serviceprofileorganization => "${ciscoucs_modify_serviceprofile_boot_policy['serviceprofileorganization']}",
}


