class kali_fuzzing::install{
  package { ['kali-tools-fuzzing']:
    ensure => 'installed',
  }
}
