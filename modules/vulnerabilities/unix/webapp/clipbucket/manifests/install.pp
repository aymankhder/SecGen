class clipbucket::install {
  $docroot = '/var/www/clipbucket'

  # TODO: parameterise me
  $dbname = 'test'
  $dbhost = 'localhost'
  $dbuser = 'test'
  $dbpass = 'test'
  $base_url = 'http://172.0.16.2'

  Exec { path => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'] }

  # Install dependencies
  package { ['mplayer', 'mencoder', 'libogg-dev', 'libvorbis-dev', 'lame', 'php', 'php-gd', 'phpmyadmin', 'ruby',
    'ffmpeg', 'gpac', 'imagemagick', 'php-imagick' ]:
    ensure => installed,
  }

  package { 'flvtool2':
    ensure   => installed,
    provider => 'gem',
    require  => Package['ruby']
  }

  # Move webapp files
  file { $docroot:
    ensure  => directory,
    recurse => true,
    source  => 'puppet:///modules/clipbucket/upload'
  }

  file { "$docroot/logs/":
    ensure  => directory,
    require => File[$docroot]
  }

  # Set permissions
  exec { 'clipbucket install set modes':
    cwd     => $docroot,
    command => "sudo chmod 777 $docroot/files/ $docroot/images/ $docroot/styles/ $docroot/includes/ $docroot/player/ $docroot/cache/ $docroot/logs/ -R",
    require => File[[$docroot, "$docroot/logs"]]
  }

  file { "/tmp/cb_new_install.sql":
    ensure  => file,
    content => template('clipbucket/cb_new_install.sql.erb'),
  }

  ::mysql::db { $dbname:
    user           => $dbuser,
    password       => $dbpass,
    host           => $dbhost,
    grant          => ['SELECT', 'UPDATE'],
    sql            => '/tmp/cb_new_install.sql',
    import_timeout => 0,
    require        => File['/tmp/cb_new_install.sql']
  }

  file { "$docroot/includes/dbconnect.php":
    ensure  => present,
    content => template('clipbucket/dbconnect.php.erb'),
  }

  ###############
  # Install steps on web application:
  #
  # 1. Agreement
  # 2. Approve Pre Check
  # 3. Approve Permissions
  # 4. Database
  # 5. Data import
  # 6. Admin Settings
  # 7. Site Settings
  # 7.5 remove /var/www/cb_install
  # 8. Register
  # 9. Finish





}

# now your website is almost ready to go, but you have to change some settings from the Administrator Panel
# Settings In Admin Panel
#
# First You have to access to the admin panel and by using this url http://yourwebsites.com/admin_area
#
# Enter username and password to login as Super Admin
# username : admin
# password : admin
# After Logging in go to Super Admin Settings
# Change the username and pass to whatever you want, but make is so complicate so that no one able to guess it
# Now Create an Admin by clicking 'Add Member' found under User Management Menu
# Fill The Form and Set its User Access Level to Admin and Submit it, and use this user as Admin
# NOTE : DO NOT PERFORM ANY ACTION OTHER THAN USERMANAGMENT USING SUPERADMIN
# Now logout and Login as Your newly created admin
#
# Setting Website Configurations
#
# Website Settings
# Website Title "Your Website Title" ie "Best Website"
# Website Slogan ie "We Are The Best";
# Website Closed (If You Are Editing or Doing Maintenance) Yes/No
# Website Closed Message is Displayed When You Have Closed Your Website
# Set Meta Description according to your website content
# Set Meta Keywords According to your website Content
# Turn on/of SEO Url
# Paths
# FFMPEG Binary Path (Set FFMPEG path, where FFMPEG is installed)
# FLVTool2 Path (Set Flv Tool 2 Path)
# Mencoder Path (Set Mencoder Path)
# Mplayer Path (Set Mplayer Path)
# PHP Path ( Set PHP Path)
# Video, Uploading and Conversion Settings
# Max Upload Size (Set the Maximum Size of the File you want to be uploaded )
# Video Comments (Turn on or off Video Comments) Yes/No
# Video Embedding (Turn on or off Video Embedding) Yes/No
# Video Rating (Turn on or off Video Rating) Yes/No
# Video Comments Rating (Turn on or off Video Comments Rating ) Yes/No
# Resize The Uploaded Video or Not
# if yes the Set Resize Height and Resized Width
# Set Other Video Settings Accordingly
# Keep Original File for Download (Turn on or off ) Yes/No
# Video Activation Required (Turn on or off ) Yes/No
# Display Settings
# Template Name ( Select Available Template From The list)
# Flash Player ( Select Available Flash Player From The list)
# Video List Per Page ( Number Of Videos List Per Page )
# Video List Per Box ( Number Of VIdeo List in a Box, Tab or other than Main or Videos Page)
# Channel List Per Page ( Number Of Channels List Per Page)
# Channels List Per Box ( Number OF Channels List Per Box , Tab or Other than main or Channels Page)
# Set Number Of Search Results Display
# Set Number of Recently Viewed Videos in a Flash Widget
# User Registration
# Turn On/Off User Registrations
# Set on/Off Email Verification
#
#
#
# Your Basic Installation is Done and Your website is ready to Launch