include ciscoucs
import '../data.pp'

transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}",
 
}

ciscoucs_serviceprofile_bootpolicy{'serviceprofile_dn': 
  #serviceprofile_dn =>"${ciscoucs_serviceprofile_bootpolicy['serviceprofile_dn']}",
  transport      => Transport_ciscoucs['ciscoucs'],
  ensure         => "${ciscoucs_serviceprofile_bootpolicy['ensure']}",
  #bootpolicy_dn   => "${ciscoucs_serviceprofile_bootpolicy['bootpolicy_dn']}",
  
   bootpolicy_name => "${ciscoucs_serviceprofile_bootpolicy['bootpolicy_name']}",
   bootpolicy_organization => "${ciscoucs_serviceprofile_bootpolicy['bootpolicy_organization']}",
   
   serviceprofile_name => "${ciscoucs_serviceprofile_bootpolicy['serviceprofile_name']}",
   serviceprofile_organization => "${ciscoucs_serviceprofile_bootpolicy['serviceprofile_organization']}",
}


