include apache

$tool_name = "little-dipper"

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

vcsrepo { "/var/www/pythonapp/${tool_name}":
  require => [package['git'],file['/var/www/pythonapp']],
  ensure => present,
  provider => git,
  source => "https://github.com/mattcriswell/${tool_name}.git"
}

package { "epel-release.noarch":
  ensure => present,
  require => exec['yum-update'],
}

package { "python-flask.noarch":
  ensure => present,
  require => package['epel-release.noarch'],
}

package { "git":
  ensure => present,
}

apache::vhost { "${tool_name}.example.com":
  require		      => [vcsrepo["/var/www/pythonapp/${tool_name}"], file['/var/www/pythonapp'], package['python-flask.noarch']],
  port                        => '80',
  docroot                     => '/var/www/pythonapp',
  wsgi_application_group      => '%{GLOBAL}',
  wsgi_daemon_process         => "${tool_name}",
  wsgi_daemon_process_options => {
    processes    => '2',
    threads      => '15',
    display-name => '%{GROUP}',
   },
  wsgi_import_script          => "/var/www/pythonapp/${tool_name}/demo.wsgi",
  wsgi_import_script_options  =>
    { process-group => "${tool_name}", application-group => '%{GLOBAL}' },
  wsgi_process_group          => "${tool_name}",
  wsgi_script_aliases         => { '/' => "/var/www/pythonapp/${tool_name}/demo.wsgi" },
}
