class kibana_7 () {

  Exec { path => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'] }

  class { 'kibana_7::install': }->
  class { 'kibana_7::config':
    elasticsearch_ip => $elasticsearch_ip,
    elasticsearch_port => $elasticsearch_port,
    kibana_port => $kibana_port,
  } ->
  class { 'kibana_7::service':}

}