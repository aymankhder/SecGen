class change_timestamp_last_access_time::change_timestamp_last_access_time ($file_path, $file_time) {
  exec { 'change_last_access_time':
    command   => "$((ls ${file_path}).LastAccessTime = '${file_time}')",
    provider  => powershell,
  }
}