include ciscoucs
import '../data.pp'

transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}",
 
}

ciscoucs_serviceprofile_clone { 'sourceprofilename':
   ensure         => "${ciscoucs_serviceprofile_clone['ensure']}",
   transport  => Transport_ciscoucs['ciscoucs'],
   source_profile_dn => "${ciscoucs_serviceprofile_clone['source_profile_dn']}",
   target_profile_dn => "####", 
   #source_serviceprofile_name      => "${ciscoucs_serviceprofile_clone['source_serviceprofile_name']}",
   #source_organization => "${ciscoucs_serviceprofile_clone['source_organization']}",
   #target_serviceprofile_name      => "${ciscoucs_serviceprofile_clone['target_serviceprofile_name']}",
   #target_organization => "${ciscoucs_serviceprofile_clone['target_organization']}",
}



