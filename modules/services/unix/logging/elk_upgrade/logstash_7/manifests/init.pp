class logstash_7() {

  Exec { path => ['/bin','/sbin','/usr/bin', '/usr/sbin'] }

  class { 'logstash_7::install':
  }->
  class { 'logstash_7::config':
    elasticsearch_ip => $elasticsearch_ip,
    elasticsearch_port => $elasticsearch_port,
    logstash_port => $logstash_port,
    log_path => $log_path,
    data_path => $data_path,
    config_path => $config_path,
  }->
  class { 'logstash_7::service':}

}