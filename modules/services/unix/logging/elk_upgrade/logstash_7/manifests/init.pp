class logstash_7() {

  Exec { path => ['/bin','/sbin','/usr/bin', '/usr/sbin'] }

  ## Add logstash repository
  # class { 'logstash_7::install':
  #   package_url => $package_url,
  # }->
  # class { 'logstash_7::config':
  #   api_host => $api_host,
  #   api_port => $api_port,
  # }->
  # class { 'logstash_7::service':}


}