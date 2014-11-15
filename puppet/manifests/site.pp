file {'/tmp/test1':
      ensure  => file,
      content => "Hi.\n",
}

exec { 'yum-update': command => "/bin/yum update -y" }

file {'/var/www/html/helloworld.wsgi':
  ensure => file,
  content => "from flask import Flask
app = Flask(__name__)

@app.route('/')
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

apache::vhost { 'test.example.com':
  require => [file['/var/www/html/helloworld.wsgi'], package['python-flask.noarch']],
  port => '80',
  docroot => '/var/www/html',
  wsgi_daemon_process => 'wsgi',
  wsgi_application_group => '%{GROUP}',
  wsgi_daemon_process_options => {
    processes => '2',
    threads => '15',
    display-name => '%{GROUPS}',
  },
  wsgi_import_script => '/var/www/html/helloworld.wsgi',
  wsgi_import_script_options =>
    { process-group => 'wsgi', application-group => '%{GLOBAL}' },
  wsgi_process_group => 'wsgi',
  wsgi_script_alias => { '/' => "/var/www/html/helloworld.wsgi" },
}
