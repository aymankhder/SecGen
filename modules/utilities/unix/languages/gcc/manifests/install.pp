class gcc::install {
  package { ['build-essential', 'gcc-multilib']:
    ensure => 'installed',
  }
}
