include apache

exec { 'iptables-flush': command => "/usr/sbin/iptables -F" }
exec { 'disable-selinux': command => "/sbin/setenforce 0" }

service { 'iptables':
  require => exec['iptables-flush'],
  ensure => stopped,
}

exec { 'yum-update': command => "/bin/yum update -y" }

file {'/var/www':
  ensure => directory,
  mode => 0755,
}

file {'/var/www/pythonapp':
  require => file['/var/www'],
  ensure => directory,
  mode => 0777,
}

file {'/var/www/pythonapp/demo.wsgi':
  require => file['/var/www'],
  ensure => present,
}

package { "epel-release.noarch":
  ensure => present,
  require => exec['yum-update'],
}

package { "python-flask.noarch":
  ensure => present,
  require => package['epel-release.noarch'],
}

apache::vhost { 'wsgi.example.com':
  require		      => [file['/var/www/pythonapp/demo.wsgi'], file['/var/www/pythonapp'], package['python-flask.noarch']],
  port                        => '80',
  docroot                     => '/var/www/pythonapp',
  wsgi_application_group      => '%{GLOBAL}',
  wsgi_daemon_process         => 'wsgi',
  wsgi_daemon_process_options => {
    processes    => '2',
    threads      => '15',
    display-name => '%{GROUP}',
   },
  wsgi_import_script          => '/var/www/demo.wsgi',
  wsgi_import_script_options  =>
    { process-group => 'wsgi', application-group => '%{GLOBAL}' },
  wsgi_process_group          => 'wsgi',
  wsgi_script_aliases         => { '/' => '/var/www/pythonapp/demo.wsgi' },
}
