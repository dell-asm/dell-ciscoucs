include ciscoucs

transport_ciscoucs { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '192.168.40.131',
}

update_boot_policy { 'bootpolicyname':
   ensure    => present,
   transport  => Transport_ciscoucs['ciscoucs'],
   bootpolicyname => 'testbootpolicy',
   key => 'org-root/ls-testing',
   status => '',
}
