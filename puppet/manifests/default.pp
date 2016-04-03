exec { "apt-get -y update":
    command => "/usr/bin/apt-get update",
}

exec { "apt-get -y install postgresql libpq-dev --fix-missing":
    command => "/usr/bin/apt-get install postgresql libpq-dev --fix-missing",
}
exec { "apt-get upgrade":
    command => "/usr/bin/apt-get -y upgrade",
}


class install_postgres {
  class { 'postgresql': }

  class { 'postgresql::server':
    listen => ['*', ],
    port   => 5432,
    acl   => ['host all all 0.0.0.0/0 md5', ],  
  }

  pg_database { ['data']:
    ensure   => present,
    encoding => 'UTF8',
    require  => Class['postgresql::server']
  }

  pg_user { 'user':
    ensure  => present,
    require => Class['postgresql::server'],
    superuser => true,
    password => 'passwd'
  }

  pg_user { 'vagrant':
    ensure    => present,
    superuser => true,
    require   => Class['postgresql::server']
  }

  package { 'libpq-dev':
    ensure => installed
  }

  package { 'postgresql-contrib':
    ensure  => installed,
    require => Class['postgresql::server'],
  }
}
class { 'install_postgres': }

package { 'curl':
  ensure => installed
}
