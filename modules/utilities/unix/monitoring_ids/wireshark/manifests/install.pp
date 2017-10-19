class wireshark::install{
  package { ['wireshark']:
    ensure => 'installed',
  }
}
