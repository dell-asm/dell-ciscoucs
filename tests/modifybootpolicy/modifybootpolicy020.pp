include ciscoucs

import '../data.pp'

transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}",
}

ciscoucs_serviceprofile_bootpolicy{'serviceprofile_dn':
  ensure                       => "${ciscoucs_serviceprofile_bootpolicy['ensure']}",
  serviceprofile_dn            =>"${ciscoucs_serviceprofile_bootpolicy['serviceprofile_dn']}",
  transport                    => Transport_ciscoucs['ciscoucs'],
  #bootpolicy_dn               => "${ciscoucs_serviceprofile_bootpolicy['bootpolicy_dn']}",
  bootpolicy_name              => "${ciscoucs_serviceprofile_bootpolicy['bootpolicy_name']}",
  bootpolicy_organization      => "orrt",
  #serviceprofile_name         => "${ciscoucs_serviceprofile_bootpolicy['serviceprofile_name']}",
  #serviceprofile_organization => "${ciscoucs_serviceprofile_bootpolicy['serviceprofile_organization']}",
}