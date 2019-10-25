class nc_message::install {
  package { 'nmap':
    ensure => installed
  }

  $secgen_parameters = secgen_functions::get_parameters($::base64_inputs_file)
  $port = $secgen_parameters['port'][0]

  $strings_to_leak = join($secgen_parameters['strings_to_leak'], ",")
  # $leaked_filenames = $secgen_parameters['leaked_filenames']


  # run on each boot via cron
  cron { "backdoor$port":
    command     => "sleep 60 && ncat -l -p $port -c 'echo $strings_to_leak' -k &",
    special     => 'reboot',
  }

}
