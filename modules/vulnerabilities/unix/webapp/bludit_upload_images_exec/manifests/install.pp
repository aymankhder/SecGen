class bludit_upload_images_exec::install {
  # sets the default paths to use
  Exec { path => ['/bin', '/usr/bin', '/usr/local/bin', '/sbin', '/usr/sbin'] }

  ensure_packages(['php-xml','php-gd','php.mbstring','php-json'])
  case $operatingsystemrelease {
    /^(9|10).*/: { # do 9.x stretch stuff
      ensure_packages('php5.6-gd')
    }
  }

  # copy and unzip archive
  $archive = 'bludit-3-9-2.zip'
  file { "/usr/local/src/$archive":
    ensure => file,
    source => "puppet:///modules/bludit_upload_images_exec/$archive",
  } ->
  exec { 'unpack-bludit':
    cwd => '/usr/local/src',
    command => "unzip $archive -d /var/www",
  } ->
  exec { 'chown-bludit':
    command => "chown www-data. /var/www -R",
  }


}
