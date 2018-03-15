$secgen_parameters = ::secgen_functions::get_parameters($::base64_inputs_file)
$version = $secgen_parameters['version'][0]
$blog_title = $secgen_parameters['blog_title'][0]
$admin_email = $secgen_parameters['admin_email'][0]
$admin_password = $secgen_parameters['admin_password'][0]
$username = $secgen_parameters['username'][0]

class { 'mysql::server': }
class { 'mysql::bindings': php_enable => true, }

class { '::apache':
  default_vhost => false,
  overwrite_ports => false,
  default_mods => ['rewrite', 'php'],
}

apache::vhost { 'wordpress':
  docroot => '/var/www/wordpress',
  port    => '80',
}

class { 'wordpress':
  install_dir => '/var/www/wordpress',
  version => $version,
} ~>
class { 'wordpress::conf':
  version => $version,
}

# TODO:
# Configuration
## Pass an account in?
# HTTPS true/false
#

# wordpress conf

# Older versions (1.2.1)

# GET /wp-admin/install.php HTTP/1.1
# Host: 172.16.0.2
# User-Agent: Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:58.0) Gecko/20100101 Firefox/58.0
# Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
# Accept-Language: en-US,en;q=0.5
# Accept-Encoding: gzip, deflate
# Referer: http://172.16.0.2/
# Cookie: wp-settings-time-1=1521034877
# Connection: close
# Upgrade-Insecure-Requests: 1
#
# GET /wp-admin/install.php?step=1 HTTP/1.1
# Host: 172.16.0.2
# User-Agent: Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:58.0) Gecko/20100101 Firefox/58.0
# Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
# Accept-Language: en-US,en;q=0.5
# Accept-Encoding: gzip, deflate
# Referer: http://172.16.0.2/wp-admin/install.php
# Cookie: wp-settings-time-1=1521034877
# Connection: close
# Upgrade-Insecure-Requests: 1
#
# GET /wp-admin/install.php?step=2 HTTP/1.1
# Host: 172.16.0.2
# User-Agent: Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:58.0) Gecko/20100101 Firefox/58.0
# Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
# Accept-Language: en-US,en;q=0.5
# Accept-Encoding: gzip, deflate
# Referer: http://172.16.0.2/wp-admin/install.php?step=1
# Cookie: wp-settings-time-1=1521034877
# Connection: close
# Upgrade-Insecure-Requests: 1
#
# POST /wp-admin/install.php?step=3 HTTP/1.1
# Host: 172.16.0.2
# User-Agent: Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:58.0) Gecko/20100101 Firefox/58.0
# Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
# Accept-Language: en-US,en;q=0.5
# Accept-Encoding: gzip, deflate
# Referer: http://172.16.0.2/wp-admin/install.php?step=2
# Content-Type: application/x-www-form-urlencoded
# Content-Length: 34
# Cookie: wp-settings-time-1=1521034877
# Connection: close
# Upgrade-Insecure-Requests: 1
#
# step=3&url=http%3A%2F%2F172.16.0.2

# 1.5.1
#
# POST /wp-admin/install.php?step=2 HTTP/1.1
# Host: 172.16.0.2
# User-Agent: Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:58.0) Gecko/20100101 Firefox/58.0
# Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
# Accept-Language: en-US,en;q=0.5
# Accept-Encoding: gzip, deflate
# Referer: http://172.16.0.2/wp-admin/install.php?step=1
# Content-Type: application/x-www-form-urlencoded
# Content-Length: 83
# Cookie: wp-settings-time-1=1521034877
# Connection: close
# Upgrade-Insecure-Requests: 1
#
# weblog_title=test&admin_email=test%40test.com&Submit=Continue+to+Second+Step+%C2%BB


# 2.0

# 2.5
#
# POST /wp-admin/install.php?step=2 HTTP/1.1
# Host: 172.16.0.2
# User-Agent: Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:58.0) Gecko/20100101 Firefox/58.0
# Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
# Accept-Language: en-US,en;q=0.5
# Accept-Encoding: gzip, deflate
# Referer: http://172.16.0.2/wp-admin/install.php
# Content-Type: application/x-www-form-urlencoded
# Content-Length: 84
# Cookie: wp-settings-time-1=1521034877
# Connection: close
# Upgrade-Insecure-Requests: 1
#
# weblog_title=test&admin_email=test%40test.com&blog_public=1&Submit=Install+WordPress


# 2.9

# POST /wp-admin/install.php?step=2 HTTP/1.1
# Host: 172.16.0.2
# User-Agent: Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:58.0) Gecko/20100101 Firefox/58.0
# Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
# Accept-Language: en-US,en;q=0.5
# Accept-Encoding: gzip, deflate
# Referer: http://172.16.0.2/wp-admin/install.php
# Content-Type: application/x-www-form-urlencoded
# Content-Length: 84
# Cookie: wp-settings-time-1=1521034877
# Connection: close
# Upgrade-Insecure-Requests: 1
#
# weblog_title=test&admin_email=test%40test.com&blog_public=1&Submit=Install+WordPress

# 3.0
# POST /wp-admin/install.php?step=2 HTTP/1.1
# Host: 172.16.0.2
# User-Agent: Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:58.0) Gecko/20100101 Firefox/58.0
# Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
# Accept-Language: en-US,en;q=0.5
# Accept-Encoding: gzip, deflate
# Referer: http://172.16.0.2/wp-admin/install.php
# Content-Type: application/x-www-form-urlencoded
# Content-Length: 141
# Cookie: wp-settings-time-1=1521034877
# Connection: close
# Upgrade-Insecure-Requests: 1
#
# weblog_title=test&user_name=admin&admin_password=test&admin_password2=test&admin_email=test%40test.com&blog_public=1&Submit=Install+WordPress


# 4.2
#
# POST /wp-admin/install.php?step=2 HTTP/1.1
# Host: 172.16.0.2
# User-Agent: Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:58.0) Gecko/20100101 Firefox/58.0
# Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
# Accept-Language: en-US,en;q=0.5
# Accept-Encoding: gzip, deflate
# Referer: http://172.16.0.2/wp-admin/install.php
# Content-Type: application/x-www-form-urlencoded
# Content-Length: 159
# Cookie: wp-settings-time-1=1521034877
# Connection: close
# Upgrade-Insecure-Requests: 1
#
# weblog_title=test&user_name=user&admin_password=password&admin_password2=password&admin_email=test%40email.com&blog_public=1&Submit=Install+WordPress&language=


# 4.3 (default generated password)
#
# POST /wp-admin/install.php?step=2 HTTP/1.1
# Host: 172.16.0.2
# User-Agent: Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:58.0) Gecko/20100101 Firefox/58.0
# Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
# Accept-Language: en-US,en;q=0.5
# Accept-Encoding: gzip, deflate
# Referer: http://172.16.0.2/wp-admin/install.php
# Content-Type: application/x-www-form-urlencoded
# Content-Length: 181
# Cookie: wp-settings-time-1=1521034877
# Connection: close
# Upgrade-Insecure-Requests: 1
#
# weblog_title=test&user_name=test&admin_password=test&pass1-text=QjqKmEYBWqQ4LLTp5D&admin_password2=test&admin_email=test%40test.test&blog_public=1&Submit=Install+WordPress&language=


# 4.3 (user supplied weak password)
# secure password with pw_weak=on works! just always include the parameter.
#
# POST /wp-admin/install.php?step=2 HTTP/1.1
# Host: 172.16.0.2
# User-Agent: Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:58.0) Gecko/20100101 Firefox/58.0
# Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
# Accept-Language: en-US,en;q=0.5
# Accept-Encoding: gzip, deflate
# Referer: http://172.16.0.2/wp-admin/install.php
# Content-Type: application/x-www-form-urlencoded
# Content-Length: 177
# Cookie: wp-settings-time-1=1521034877
# Connection: close
# Upgrade-Insecure-Requests: 1
#
# weblog_title=test&user_name=user&admin_password=test&pass1-text=test&admin_password2=test&pw_weak=on&admin_email=test%40test.com&blog_public=1&Submit=Install+WordPress&language=


# 1.5.1
# weblog_title=test&admin_email=test%40test.com&Submit=Continue+to+Second+Step+%C2%BB

# 2.0 - 2.9
# weblog_title=test&admin_email=test%40test.com&blog_public=1&Submit=Install+WordPress

# 3.0
# weblog_title=test&user_name=admin&admin_password=test&admin_password2=test&admin_email=test%40test.com&blog_public=1&Submit=Install+WordPress

# 4.2
# weblog_title=test&user_name=user&admin_password=password&admin_password2=password&admin_email=test%40email.com&blog_public=1&Submit=Install+WordPress&language=

# 4.3
# weblog_title=test&user_name=test&admin_password=test&pass1-text=QjqKmEYBWqQ4LLTp5D&admin_password2=test&admin_email=test%40test.test&blog_public=1&Submit=Install+WordPress&language=
# weblog_title=test&user_name=user&admin_password=test&pass1-text=test&admin_password2=test&pw_weak=on&admin_email=test%40test.com&blog_public=1&Submit=Install+WordPress&language=