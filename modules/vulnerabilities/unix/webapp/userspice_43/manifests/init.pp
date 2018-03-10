class userspice_43 {
  class { 'userspice_43::apache': } ~>
  class { 'userspice_43::install': }
}
