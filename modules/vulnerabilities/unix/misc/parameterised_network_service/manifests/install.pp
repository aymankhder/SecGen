class parameterised_network_service::install {

  # Apply default CSS template
  file { "/tmp/c_code.c":
    ensure => file,
    content => template('parameterised_network_service/c_code.c.erb')
  }

}