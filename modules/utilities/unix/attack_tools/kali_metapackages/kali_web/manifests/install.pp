class kali_web::install{

  Exec{
    path => ['/bin', '/usr/bin', '/usr/local/bin', '/sbin', '/usr/sbin'],
  }

  package { ['kali-tools-web']:
    ensure => 'installed',
  } ~>
  exec { 'safely remove the zaproxy package':
    command => "apt-cache depends kali-tools-web | grep 'Depends:' | awk {'print \$2'} | xargs apt-mark manual && apt-get remove zaproxy"
  } ~>
  exec { 'create /opt/zaproxy-2.9.0':
    command => 'mkdir /opt/zaproxy-2.9.0',
  } ~>
  file { '/opt/zaproxy-2.9.0/zaproxy_2.9.0-0kali1_all.deb':
    source => 'puppet:///modules/kali_web/zaproxy_9.2.0-0kali1_all.deb'
  } ~>
  exec { 'install zap 2.9.0':
    command => 'dpkg -i /opt/zaproxy-2.9.0/zaproxy_2.9.0-0kali1_all.deb',
  }
}

# Temporary changes:
#   Safely remove just the zaproxy package: (apt-cache depends kali-tools-web | grep 'Depends:' | awk {'print $2'} | xargs apt-mark manual) && apt-get remove zaproxy
#   install the zaproxy-2.9.0-0kali1 debian package
