include ciscoucs

import 'data.pp'

transport_ciscoucs { 'ciscoucs':
  username => "${ciscoucs['username']}",
  password => "${ciscoucs['password']}",
  server   => "${ciscoucs['server']}",
 
}

ciscoucs_serviceprofile { 'name':
  name        => "${ciscoucs_poweronoff['name']}",
  org         => "${ciscoucs_poweronoff['org']}",
  dn         => "${ciscoucs_poweronoff['dn']}",
  power_state => "${ciscoucs_poweronoff['power_state']}",
}

