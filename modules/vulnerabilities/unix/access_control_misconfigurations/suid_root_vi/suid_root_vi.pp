class {'uid_vi_root::change_uid_permissions':
  file_input => {
    '/usr/bin/vi' => '4755',
    '/etc/alternatives/vi' => '4755',
    '/usr/bin/vim.tiny'    => '4755',
  }
}
