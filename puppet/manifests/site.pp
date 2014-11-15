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

file {'/var/www/demo.wsgi':
  require => file['/var/www'],
  ensure => file,
  content => "from flask import Flask
application = Flask(__name__)

@application.route('/')
def hello_world():
    return 'Hello World!'

if __name__ == '__main__':
    app.run()",
}


package { "epel-release.noarch":
  ensure => present,
  require => exec['yum-update'],
}

package { "python-flask.noarch":
  ensure => present,
  require => package['epel-release.noarch'],
}

class { 'apache': }

apache::vhost { 'wsgi.example.com':
  require		      => [file['/var/www/demo.wsgi'], file['/var/www/pythonapp'], package['python-flask.noarch']],
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
  wsgi_script_aliases         => { '/' => '/var/www/demo.wsgi' },
}
