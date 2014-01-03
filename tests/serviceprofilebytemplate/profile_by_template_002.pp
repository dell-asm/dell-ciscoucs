include ciscoucs

import '../data.pp'

# As a user I want to create multiple instances of a Service Profile.

transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}",
 
}


ciscoucs_serviceprofile { 'name':
  name        => "${ciscoucs_serviceprofile['name']}",
  org         => "${ciscoucs_serviceprofile['org']}",
  dn         => "${ciscoucs_serviceprofile['dn']}",
  ensure  => "${ciscoucs_serviceprofile['ensure']}",
  source_template => "${ciscoucs_serviceprofile['source_template']}",
  number_of_profiles => "${ciscoucs_serviceprofile['number_of_profiles']}",
  transport   => Transport_ciscoucs['ciscoucs'],
}
