class elasticsearch_7::service {
  service { 'elasticsearch':
    ensure  => running,
    enable  => true,
    hasrestart  => true,
  }
}
