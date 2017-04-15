class change_timestamp_last_write_time::change_timestamp_last_write_time ($file_path, $file_time) {
  exec { 'change_last_write_time':
    command   => "$((ls ${file_path}).LastWriteTime = '${file_time}')",
    provider  => powershell,
  }
}