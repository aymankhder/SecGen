class after_login_message::init {

  $secgen_parameters = secgen_functions::get_parameters($::base64_inputs_file)
  $leaked_strings = join($secgen_parameters['$leaked_strings'], "/n")
 
  file_line { "$leaked_strings leak login":
    path => '/etc/bashrc',
    line => "cat <<'EOF'\n$leaked_strings\nEOF",
  }

}
