include ciscoucs

transport_ciscoucs { 'ciscoucs':
  username => 'admin',
  password => 'admin',
  server   => '192.168.24.130',
}

ciscoucs_update_boot_policy { 'bootpolicyname':
   ensure    => present,
   transport  => Transport_ciscoucs['ciscoucs'],
   bootpolicyname => 'testbootpolicy',
   dn => 'org-root/ls-test_123',
   organization => 'org-root',
}
