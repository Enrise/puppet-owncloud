# Class: owncloud::repository
#
# This class installs owncloud repositories.
# Required for installation based on package
#
# == Variables
#
# Refer to owncloud class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It's automatically included by owncloud main class.
# This class uses default file and exec defines to avoid more
# Example42 dependencies (sigh)
#
class owncloud::repository inherits owncloud {

  case $::operatingsystem {

    ubuntu , debian: {
      file { 'owncloud.list':
        ensure  => present,
        path    => '/etc/apt/sources.list.d/owncloud.list',
        mode    => '0644',
        owner   => 'root',
        group   => 'root',
        content => $owncloud::apt_entry,
        before  => Exec['aptkey_add_owncloud'],
      }
      exec { 'aptkey_add_owncloud':
        command => "wget -O - ${apt_key_url} | apt-key add -",
        unless  => "apt-key list | grep -q ${owncloud::apt_key_id}",
        path    => '/bin:/usr/bin',
      }
      exec { 'aptget_update_owncloud':
        command     => 'apt-get update',
        refreshonly => true,
        subscribe   => File['owncloud.list'],
        path        => '/bin:/usr/bin',
      }

    }

    default: {
    }

  }

}
