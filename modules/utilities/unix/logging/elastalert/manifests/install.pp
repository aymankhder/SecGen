class elastalert::install ($elasticsearch_ip, $elasticsearch_port,$installdir = '/opt/elastalert/', $source='http://github.com/Yelp/elastalert') {
  Exec { path => ['/bin', '/usr/bin', '/usr/local/bin', '/sbin', '/usr/sbin'] }

  ensure_packages(['python-pip3','build-essential','libssl-dev','libffi-dev','python-dev'])
  ensure_packages(['PyYAML>=5.1','elastalert'], { provider => 'pip3', require => [Package['python-pip3']] })

  # Create directory to install into   TODO: Change this to another variable name.  Should put configs in /etc/ probably if we're installing via...
  file { $installdir:
    ensure => directory,
  }

  # Clone elastalert from Github
  vcsrepo { 'elastalert':
    ensure   => present,
    provider => git,
    path     => $installdir,
    source   => $source,
    require  => File[$installdir],
    # TODO: test with the latest version
    # revision => '98c7867',   # reset to 0.1.39
  }

  # exec { 'setup.py install':
  #   command => '/usr/bin/python2.7 setup.py install',
  #   cwd => '/opt/elastalert',
  #   require => Vcsrepo['elastalert'],
  # }

}
