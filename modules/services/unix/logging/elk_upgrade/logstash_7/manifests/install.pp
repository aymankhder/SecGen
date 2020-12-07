class logstash_7::install () {
  package { 'logstash':
    ensure => present,
    requires => Exec['es update apt'],
  }
}
