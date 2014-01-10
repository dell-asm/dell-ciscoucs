include ciscoucs

import 'data.pp'

transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}",
}

ciscoucs_serviceprofile { 'name':
  serviceprofile_name   => "${ciscoucs_serviceprofile['serviceprofile_name']}",
  organization          => "${ciscoucs_serviceprofile['organization']}",
  profile_dn            => "${ciscoucs_serviceprofile['profile_dn']}",
  ensure                => "${ciscoucs_serviceprofile['ensure']}",
  source_template       => "${ciscoucs_serviceprofile['source_template']}",
  transport             => Transport_ciscoucs['ciscoucs'],
  number_of_profiles    => "${ciscoucs_serviceprofile['number_of_profiles']}",
}
