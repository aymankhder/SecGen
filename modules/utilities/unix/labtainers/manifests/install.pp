class labtainers::install{
  # $json_inputs = base64('decode', $::base64_inputs)
  # $secgen_parameters = parsejson($json_inputs)
  # $server_ip = $secgen_parameters['server_ip'][0]
  # $port = $secgen_parameters['port'][0]


  # these are also installed by the install script, but good to use puppet where possible
  package { ['apt-transport-https', 'ca-certificates', 'curl', 'gnupg2', 'software-properties-common', 'python-pip', 'openssh-server']:
    ensure   => 'installed',
  } ->

  file { '/opt/labtainers':
    ensure => directory,
    recurse => true,
    source => 'puppet:///modules/labtainers/Labtainer-master',
    mode   => '0766',
    owner => 'root',
    group => 'root',
  } ->
  file { '/opt/labtainers/setup_scripts/modified-install-docker-debian.sh':
    source => 'puppet:///modules/labtainers/labtainer.files/modified-install-docker-debian.sh',
    mode   => '0766',
    owner => 'root',
    group => 'root',
  } ->
  exec { 'install script':
    command  => '/opt/labtainers/setup_scripts/modified-install-docker-debian.sh',
    provider => shell,
  }

}
