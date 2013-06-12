class owncloud::package {

  include owncloud::repository

  package  { $owncloud::packages:
    ensure => $owncloud::ensure,
    require => Class['owncloud::repository'],
  }

  # git::repo { 'owncloud':
    # git_tag => 'v5.0.4',
    # path  => $owncloud::server::path,
    # source  => 'git://github.com/owncloud/core.git',
    # owner   => $owncloud::server::user,
    # group   => $owncloud::server::user,
    # mode  => 0644,
  # }

}
