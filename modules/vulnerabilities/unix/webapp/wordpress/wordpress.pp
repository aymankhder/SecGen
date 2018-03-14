$secgen_parameters = ::secgen_functions::get_parameters($::base64_inputs_file)
$version = $secgen_parameters['version'][0]

class { 'mysql::server': }
class { 'mysql::bindings': php_enable => true, }

class { '::apache':
  default_vhost => false,
  overwrite_ports => false,
  default_mods => ['rewrite', 'php'],
}

apache::vhost { 'wordpress':
  docroot => '/var/www/wordpress',
  port    => '80',
}

class { 'wordpress':
  install_dir => '/var/www/wordpress',
  version => $version,
}