class before_login_message::init {

  $secgen_parameters = secgen_functions::get_parameters($::base64_inputs_file)
  $leaked_strings = join($secgen_parameters['$leaked_strings'], "/n")
 
  file_line { "$leaked_strings leak":
    path => '/etc/issue',
    line => $leaked_strings,
 }
 file_line { "$leaked_strings net leak":
    path => '/etc/issue.net',
    line => $leaked_strings,
 }
}
