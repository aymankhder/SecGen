$secgen_params = secgen_functions::get_parameters($::base64_inputs_file)
$images = $secgen_params['images']

# install
include 'docker'

# TODO: configure proxy via secgen argument?
#class { 'docker':
#  proxy => "http://172.22.0.51:3128",
#}

# download (pull) a set of images
$images.each |$image| {
  docker::image { "$image": }
}

# remove proxy config (it's in the template, and this overrides)
file_line { 'remove_docker_proxy1':
  ensure            => absent,
  path              => '/etc/default/docker',
  line              => 'HTTP_PROXY=""',
}
file_line { 'remove_docker_proxy2':
  ensure            => absent,
  path              => '/etc/default/docker',
  line              => 'http_proxy=""',
}
file_line { 'remove_docker_proxy3':
  ensure            => absent,
  path              => '/etc/default/docker',
  line              => 'https_proxy=""',
}
file_line { 'remove_docker_proxy4':
  ensure            => absent,
  path              => '/etc/default/docker',
  line              => 'HTTPS_PROXY=""',
}
