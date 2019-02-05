class apt_upgrade::apt {

  notice("Running apt-upgrade module...")

  if defined('dirtycow::config') {
    notice("vulnerabilities/unix/local/dirtycow included - skipping apt-get upgrade...")
  } else {
    case $operatingsystem {
      'Debian': {
        exec { 'update':
          command   => "/usr/bin/apt-get -y upgrade",
          tries     => 5,
          try_sleep => 30,
          timeout => 0,
          logoutput   => true,
        }
      }
      'Ubuntu': {
        exec { 'update':
          command   => "/usr/bin/apt-get -y upgrade",
          tries     => 5,
          try_sleep => 30,
          timeout => 0,
          logoutput   => true,
        }
      }
    }
  }
}
