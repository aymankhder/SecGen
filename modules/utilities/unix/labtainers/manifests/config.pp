class labtainers::config{
  require labtainers::install

  $secgen_parameters = secgen_functions::get_parameters($::base64_inputs_file)
  $lab = $secgen_parameters['lab'][0]
  $accounts = $secgen_parameters['accounts']

  # Set.up labtainers for each user account
  unless $accounts == undef {
    $accounts.each |$raw_account| {
      $account = parsejson($raw_account)
      $username = $account['username']
      # set home directory
      if $username == 'root' {
        $home_dir = "/root"
      } else {
        $home_dir = "/home/$username"
      }
      $labtainer_dir = "$home_dir/labtainer"

      file { ["$home_dir/",
        "$labtainer_dir"]:
        ensure  => directory,
        owner   => $username,
        group   => $username,
      } ->

      file { "$labtainer_dir/labtainer-student":
        ensure => 'link',
        target => '/opt/labtainers/scripts/labtainer-student',
      }

      file_line { 'patch_path_labtainers':
        path  => "$home_dir/.profile",
        line  => 'export PATH=/opt/labtainers/scripts/labtainer-student/bin:/opt/labtainers/scripts/labtainer-student/lab-bin/:/opt/labtainers/setup_scripts/trunk/scripts/designer/bin:$PATH',
      }
      file_line { 'patch_path_labtainers_dir':
        path  => "$home_dir/.bashrc",
        line  => 'export LABTAINER_DIR="/opt/labtainers/"',
      }

      # autostart script
      file { ["$home_dir/.config/", "$home_dir/.config/autostart/"]:
        ensure => directory,
        owner  => $username,
        group  => $username,
      }

      file { "$home_dir/.config/autostart/auto_start_lab.desktop":
        ensure => file,
        content => template('labtainers/auto_start_lab.desktop.erb'),
        owner  => $username,
        group  => $username,
      }

      exec { 'download labs':
        command  => "sudo -u $username /opt/labtainers/setup_scripts/pull-all.sh",
        cwd => "/opt/labtainers/setup_scripts/",
        provider => shell,
      } ->
      exec { 'start lab':
        command  => "sudo -u $username bash -c 'source ~/.profile; echo -e \"email@addre.ss\\n\\n\" | /opt/labtainers/scripts/labtainer-student/bin/labtainer $lab -q'",
        cwd => "/opt/labtainers/scripts/labtainer-student/",
        provider => shell,
      }
    }
  }

}
