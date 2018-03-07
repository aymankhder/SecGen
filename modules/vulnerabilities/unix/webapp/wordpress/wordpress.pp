class { 'apache':
  mpm_module => 'prefork',
}

class { 'apache::mod::php': }
class { 'mysql::server': }
class { 'mysql::bindings': php_enable => true, }

apache::vhost { 'wordpress':
  docroot => '/opt/wordpress',
  port    => '80',
}

class { 'wordpress':
  # version => '3.4',
}