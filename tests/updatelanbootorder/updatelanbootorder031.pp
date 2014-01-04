include ciscoucs
import '../data.pp'

transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}",
 
}


ciscoucs_modify_lan_bootorder{'dn': 
  #dn             => "${ciscoucs_modify_lan_bootorder['dn']}",  
  transport      => Transport_ciscoucs['ciscoucs'],
  ensure         => "${ciscoucs_modify_lan_bootorder['ensure']}",
  bootpolicyname => "$$",
  organization   => "${ciscoucs_modify_lan_bootorder['organization']}",
  lanorder       => "${ciscoucs_modify_lan_bootorder['lanorder']}",

}


