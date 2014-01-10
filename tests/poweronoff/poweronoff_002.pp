include ciscoucs

import '../data.pp'

# Power On Service Profile operation -when profile_dn is provided.

transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}",
}

ciscoucs_serviceprofile { 'serviceprofile_name':
  #serviceprofile_name   => "",
  #organization          => "",
  profile_dn             => "${ciscoucs_serviceprofile['profile_dn']}",
  power_state            => "${ciscoucs_serviceprofile['power_state_on']}",
  transport              => Transport_ciscoucs['ciscoucs'],
}