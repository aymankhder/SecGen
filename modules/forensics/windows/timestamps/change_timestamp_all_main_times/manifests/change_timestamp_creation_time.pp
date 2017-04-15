class change_timestamp_creation_time::change_timestamp_creation_time ($file_path, $file_time) {
  exec { 'change_creation_time':
    command   => "$((ls ${file_path}).CreationTime = '${file_time}')",
    provider  => powershell,
  }
}