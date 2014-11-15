file {'/tmp/test1':
      ensure  => file,
      content => "Hi.\n",
}

exec { 'yum-update': command => "/bin/yum update -y" }

package { "epel-release.noarch":
  ensure => present,
  require => exec['yum-update'],
}

package { "python-flask.noarch":
  ensure => present,
  require => package['epel-release.noarch'],
}

class { 'apache': }

apache::vhost { 'test.example.com':
  port => '80',
  docroot => '/var/www/html',
  wsgi_daemon_process => 'wsgi',
}
