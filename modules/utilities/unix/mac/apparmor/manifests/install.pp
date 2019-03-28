class apparmor::install {

  #$secgen_parameters = secgen_functions::get_parameters($::base64_inputs_file)
  #$chroot_dir = $secgen_parameters['chroot_dir'][0]

  package { ['apparmor', 'apparmor-easyprof', 'apparmor-notify', 'apparmor-profiles', 'apparmor-profiles-extra', 'apparmor-utils', 'auditd']:
    ensure => 'installed',
  } ->

  file { "/etc/default/grub.d":
    ensure => 'directory',
  } ->

  file { "/etc/default/grub.d/apparmor.cfg":
    content => 'GRUB_CMDLINE_LINUX_DEFAULT="$GRUB_CMDLINE_LINUX_DEFAULT apparmor=1 security=apparmor"',
  } ->

  exec { "sudo update-grub":
    cwd     => '/var/tmp',
    provider     => 'shell',
    path  => ['/bin', '/usr/bin', '/usr/sbin', '/sbin',],
  }

}
