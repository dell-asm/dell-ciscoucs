include ciscoucs
import 'data.pp'

transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}",
}


ciscoucs_serviceprofile_boot_order{ 'bootpolicy_name':  
   ensure    => "${ciscoucs_serviceprofile_boot_order['ensure']}",
   transport  => Transport_ciscoucs['ciscoucs'],
   bootpolicy_dn => "${ciscoucs_serviceprofile_boot_order['bootpolicy_dn']}",
   bootpolicy_name =>"${ciscoucs_serviceprofile_boot_order['bootpolicy_name']}",
   organization => "${ciscoucs_serviceprofile_boot_order['organization']}",
   lan_order       => "${ciscoucs_serviceprofile_boot_order['lan_order']}",
 
}

