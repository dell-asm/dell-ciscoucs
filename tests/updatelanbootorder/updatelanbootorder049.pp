include ciscoucs

import '../data.pp'

transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "     ",
}

ciscoucs_serviceprofile_boot_order{'bootpolicy_dn':
  bootpolicy_dn         => "${ciscoucs_serviceprofile_boot_order['bootpolicy_dn']}",
  transport             => Transport_ciscoucs['ciscoucs'],
  ensure                => "${ciscoucs_serviceprofile_boot_order['ensure']}",
  bootpolicy_name       => "${ciscoucs_serviceprofile_boot_order['bootpolicy_name']}",
  organization          => "${ciscoucs_serviceprofile_boot_order['organization']}",
  lan_order             => "1",
}