class labtainers::install{
  # $json_inputs = base64('decode', $::base64_inputs)
  # $secgen_parameters = parsejson($json_inputs)
  # $server_ip = $secgen_parameters['server_ip'][0]
  # $port = $secgen_parameters['port'][0]


  # these are also installed by the install script, but good to use puppet where possible
  package { ['apt-transport-https', 'ca-certificates', 'curl', 'gnupg2', 'software-properties-common', 'python-pip', 'openssh-server', 'python-netaddr', 'python-parse', 'python-dateutil', 'okular', 'gnome-terminal']:
    ensure   => 'installed',
  } ->

  file { '/opt/labtainers':
    ensure => directory,
    recurse => true,
    source => 'puppet:///modules/labtainers/Labtainers-master',
    mode   => '0755',
    owner => 'root',
    group => 'root',
  } ->
  # Set permissions to enable creation of log files etc
  exec { 'permissions for logging':
    command  => "/bin/chmod a+rwt /opt/labtainers/scripts/labtainer-student/ /opt/labtainers/scripts/labtainer-instructor/ /opt/labtainers/setup_scripts/",
    provider => shell,
  } ->

  # not sure why this is required in our environment, but this fixes the script on our VM builds
  file_line { 'patch_build_image':
    path  => '/opt/labtainers/scripts/labtainer-student/bin/buildImage.sh',
    line  => '#shift 1 -- SecGen fix',
    match => 'shift 1',
  } ->

  exec { 'build capinout tool':
    command  => "/bin/bash ./mkit.sh | true",
    provider => shell,
    cwd => "/opt/labtainers/tool-src/capinout"
  }

  # pull the grading image
  docker::image { "mfthomps/labtainer.grader:latest": }

  # TODO: users added to docker group?

}
