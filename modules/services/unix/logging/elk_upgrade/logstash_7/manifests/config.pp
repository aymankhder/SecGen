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
    mode => '0640',
    owner => 'root',
    group => 'root',
    content => template('logstash_7/logstash.yml.erb')
  }

  file { '/etc/logstash/logstash.conf.d/my_ls_config':
    ensure => file,
    mode => '0640',
    owner => 'root',
    group => 'root',
    content => template('logstash_7/configfile-template.erb')
  }

}
