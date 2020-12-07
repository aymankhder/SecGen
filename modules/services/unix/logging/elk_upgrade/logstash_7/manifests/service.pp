class logstash_7::service {
  service { 'logstash':
    ensure  => running,
    enable  => true,
    hasrestart  => true,
  }
}
