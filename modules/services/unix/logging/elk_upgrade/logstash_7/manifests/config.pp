class logstash_7::config (
  $elasticsearch_ip,
  $elasticsearch_port = '9200',
  $logstash_port = '5044',
  $log_path = '/var/log/logstash',
  $data_path = '/var/lib/logstash',
  $config_path = '/etc/logstash/conf.d',
) {

  file { '/etc/logstash/logstash.yml':
    ensure => file,
    mode => '0644',
    owner => 'logstash',
    group => 'logstash',
    content => template('logstash_7/logstash.yml.erb')
  }

  file { '/etc/logstash/conf.d/':
    ensure => directory,
    mode   => '0775',
    owner  => 'logstash',
    group  => 'logstash',
  }

  file { '/etc/logstash/logstash.conf.d/':
    mode => '0775',
    ensure => directory,
    owner => 'logstash',
    group => 'logstash',
  }

  file { '/etc/logstash/logstash.conf.d/my_ls_config':
    ensure => file,
    mode => '0644',
    owner => 'logstash',
    group => 'logstash',
    content => template('logstash_7/configfile-template.erb'),
    require => File['/etc/logstash/logstash.conf.d/']
  }

}
