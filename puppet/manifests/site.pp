file {'/tmp/test1':
      ensure  => file,
      content => "Hi.\n",
}

exec { "yum-update": command => "/bin/yum update -y" }

package { "epel-release.noarch":
	  ensure => present
}

class { 'apache': }

apache::vhost { 'test.example.com':
  port => '80',
  docroot => '/var/www/html',
  wsgi_daemon_process => 'wsgi',
}
