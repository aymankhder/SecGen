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
