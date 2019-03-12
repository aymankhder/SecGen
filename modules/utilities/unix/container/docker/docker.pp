# install
include 'docker'

# download (pull) a set of images
$secgen_params = secgen_functions::get_parameters($::base64_inputs_file)
$images = $secgen_params['images']

$images.each |$image| {
  docker::image { "$image": }
}
