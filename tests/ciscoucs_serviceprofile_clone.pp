include ciscoucs
import 'data.pp'

transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}",
 
}

ciscoucs_serviceprofile_clone { 'sourceprofilename':
   ensure    =>  "${ciscoucs_clone['ensure']}",
   transport  => Transport_ciscoucs['ciscoucs'],
   sourceprofiledn => "${ciscoucs_clone['sourceprofiledn']}",
   targetprofiledn => "${ciscoucs_clone['targetprofiledn']}", 
   sourceserviceprofilename      => "${ciscoucs_clone['sourceserviceprofilename']}",
   sourceorganization => "${ciscoucs_clone['sourceorganization']}",
   targetserviceprofilename   => "${ciscoucs_clone['targetserviceprofilename']}",
   targetorganization => "${ciscoucs_clone['targetorganization']}",
}

