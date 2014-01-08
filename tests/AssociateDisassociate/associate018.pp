include ciscoucs
import '../data.pp'

transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}",
 
}

ciscoucs_serviceprofile_association { 'name':
  ensure    => "${ciscoucs_profile_association_disassociation['ensure_present']}", 
  organization => "${ciscoucs_profile_association_disassociation['organization']}",
  serviceprofile_name => "ccccccccccccccccc",
  #server_chassis_id => "${ciscoucs_profile_association_disassociation['server_chassis_id']}",
  #server_slot_id => "${ciscoucs_profile_association_disassociation['server_slot_id']}",   
  
  #profile_dn => "${ciscoucs_profile_association_disassociation['profile_dn']}",
  server_dn => "${ciscoucs_profile_association_disassociation['server_dn']}",
  
  transport      => Transport_ciscoucs['ciscoucs'],
}
