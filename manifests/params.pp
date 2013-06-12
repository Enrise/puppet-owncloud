# Class: owncloud::server::params
#
# This class defines default parameters used by the main module class phpmyadmin
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to owncloud::server class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class owncloud::params {

  ### Application related parameters

  $packages = $::operatingsystem ? {
    default => 'owncloud'
  }

  $path = '/usr/share/owncloud'
  $home_dir = '/var/lib/owncloud'

  $user           = 'owncloud'
  $passwordsalt   = undef
  $mysql_database = 'owncloud'
  $mysql_user     = 'owncloud'
  $mysql_host     = 'localhost'

  $enabled = true
  
  case $::operatingsystem {
    ubuntu: {
      case $::operatingsystemrelease {
        12.04: {
          $apt_entry  = "deb http://download.opensuse.org/repositories/isv:ownCloud:community/xUbuntu_12.04/ /"
          $apt_key_url = "http://download.opensuse.org/repositories/isv:ownCloud:community/xUbuntu_12.04/Release.key"
          $apt_key_id = "BA684223"
        }
        12.10: {
          $apt_entry  = "deb http://download.opensuse.org/repositories/isv:ownCloud:community/xUbuntu_12.10/ /"
          $apt_key_url = "http://download.opensuse.org/repositories/isv:ownCloud:community/xUbuntu_12.10/Release.key"
          $apt_key_id = "BA684223"
        }
        13.04: {
          $apt_entry  = "deb http://download.opensuse.org/repositories/isv:ownCloud:community/xUbuntu_13.04/ /"
          $apt_key_url = "http://download.opensuse.org/repositories/isv:ownCloud:community/xUbuntu_13.04/Release.key"
          $apt_key_id = "BA684223"
        }
      }
    }
    debian: {
      case $::operatingsystemrelease {
        6.0: {
          $apt_entry  = "deb http://download.opensuse.org/repositories/isv:ownCloud:community/Debian_6.0/ /"
          $apt_key_url = "http://download.opensuse.org/repositories/isv:ownCloud:community/Debian_6.0/Release.key"
          $apt_key_id = "BA684223"
        }
        7.0: {
          $apt_entry   = "deb http://download.opensuse.org/repositories/isv:ownCloud:community/Debian_7.0/ /"
          $apt_key_url = "http://download.opensuse.org/repositories/isv:ownCloud:community/Debian_6.0/Release.key"
          $apt_key_id  = "BA684223"
        }
      }
    }
    
    default: {

    }
    
  }

}
