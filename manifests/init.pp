class owncloud (
  $packages       = params_lookup( 'packages' ),
  $path           = params_lookup( 'path' ),
  $user           = params_lookup( 'user' ),
  $passwordsalt   = params_lookup( 'passwordsalt' ),
  $mysql_database = params_lookup( 'mysql_database' ),
  $mysql_user     = params_lookup( 'mysql_user' ),
  $mysql_password = params_lookup( 'mysql_password' ),
  $mysql_host     = params_lookup( 'mysql_host' ),
  $instanceid     = params_lookup( 'instanceid' ),
  $enabled        = params_lookup( 'enabled' )
  ) inherits owncloud::params {

    $ensure = $enabled ? {
      true => present,
      false => absent
    }

  include owncloud::package
  include mysql
  
  user { $owncloud::user:
    ensure  => $owncloud::ensure,
    home    => $owncloud::home_dir,
    shell   => '/bin/false',
    comment => 'Managed by Puppet',
  }
  
  mysql::query { "${name}-create_db":
    mysql_query => "CREATE DATABASE IF NOT EXISTS ${owncloud::mysql_database}",
    require     => Class[ 'mysql' ],
  }
  
  mysql::query { "${name}-create_user":
    mysql_db    => 'mysql',
    mysql_query => "grant all on ${owncloud::mysql_database}.* to \
      '${owncloud::mysql_user}'@${owncloud::mysql_host} \
       identified by '${owncloud::mysql_password}'",
    require     => Class[ 'mysql' ],
  }
  
  file { $owncloud::home_dir:
    ensure  => $owncloud::ensure,
    owner   => $owncloud::user,
    group   => $owncloud::user,
    mode    => '0600',
  }
  
  file { '/etc/owncloud/':
    ensure  => $owncloud::ensure,
    owner   => $owncloud::user,
    group   => $owncloud::user,
    mode    => '0600',
  }

  file { '/var/www/owncloud/config/config.php.puppet':
    ensure  => $owncloud::ensure,
    owner   => $owncloud::user,
    group   => $owncloud::user,
    mode    => '0600',
    content => template('owncloud/config.php.erb'),
    require => Package[$packages], # Provides /var/www/owncloud/config/
  }
  
  file { '/var/www/owncloud/config/config.php':
    ensure  => link,
    target  => '/var/www/owncloud/config/config.php.puppet',
    owner   => $owncloud::user,
    group   => $owncloud::user,
    mode    => '0600',
    force   => true,
    require => Package[$packages], # Provides /var/www/owncloud/config/
  }

  cron { 'owncloud-cron':
    command => "/usr/bin/php5 ${owncloud::path}/cron.php",
    user    => $owncloud::user,
    hour    => '*',
    minute  => '*',
  }

}
