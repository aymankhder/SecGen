class google_chrome::configure {
  # Need to ensure unique to each version of Windows,
  # different versions may have different install locations
  exec { 'google-chrome-initialize':
    require => Package[googlechrome],
    command => 'C:\windows\system32\cmd.exe /C start "" "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" https://www.google.com',
  }

  exec { 'google-chrome-kill-all-processes':
    require => Exec[google-chrome-initialize],
    command => "$cmd_executable_install_path\\cmd.exe /C \"taskkill /F /IM chrome.exe /T\""
  }
}