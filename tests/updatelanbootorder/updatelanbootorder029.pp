include ciscoucs
import '../data.pp'

transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}",
 
}


ciscoucs_modify_lan_bootorder{'dn': 
  dn             => "$",  
  transport      => Transport_ciscoucs['ciscoucs'],
  ensure         => "${ciscoucs_modify_lan_bootorder['ensure']}",
  bootpolicyname => "${ciscoucs_modify_lan_bootorder['bootpolicyname']}",
  organization   => "${ciscoucs_modify_lan_bootorder['organization']}",
  lanorder       => "${ciscoucs_modify_lan_bootorder['lanorder']}",

}


