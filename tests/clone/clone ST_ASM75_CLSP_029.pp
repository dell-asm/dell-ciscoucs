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
   #sourceprofiledn => "${ciscoucs_serviceprofile_clone['sourceprofiledn']}",
   #targetprofiledn => "${ciscoucs_serviceprofile_clone['targetprofiledn']}", 
   sourceserviceprofilename      => "${ciscoucs_serviceprofile_clone['sourceserviceprofilename']}",
   sourceorganization => "${ciscoucs_serviceprofile_clone['sourceorganization']}",
   targetserviceprofilename      => "#",
   targetorganization => "${ciscoucs_serviceprofile_clone['targetorganization']}",
}



