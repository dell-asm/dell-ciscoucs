include ciscoucs
import '../data.pp'

transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}",
 
}

ciscoucs_serviceprofile_association { 'name':
  ensure    => "${ciscoucs_profile_association_disassociation['ensure_absent']}", 
  #organization => "${ciscoucs_profile_association_disassociation['organization']}",
  #serviceprofile_name => "${ciscoucs_profile_association_disassociation['serviceprofile_name']}",
  #server_chassis_id => "${ciscoucs_profile_association_disassociation['server_chassis_id']}",
  #server_slot_id => "${ciscoucs_profile_association_disassociation['server_slot_id']}",   
  
  profile_dn => "#",
  server_dn => "${ciscoucs_profile_association_disassociation['server_dn']}",
  
  transport      => Transport_ciscoucs['ciscoucs'],
}
