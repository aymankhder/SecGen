class kibana_7::service {
  service { 'kibana':
    ensure  => running,
    enable  => true,
    hasrestart  => true,
  }
}
