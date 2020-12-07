class kibana_7 () {

  Exec { path => ['/bin','/sbin','/usr/bin', '/usr/sbin'] }

  # class { 'kibana_7::install':
  #   package_url => $package_url,
  # }->
  # class { 'kibana_7::config':
  #   api_host => $api_host,
  #   api_port => $api_port,
  # }->
  # class { 'kibana_7::service':}

}