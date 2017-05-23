# == Class profile_elasticsearch::install
#
# This class is called from profile_elasticsearch for install.
#
class profile_elasticsearch::install {
  # prevent direct use of subclass
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  class { 'java':
    distribution => 'jdk',
  }

  class {'elasticsearch':
    manage_repo  => false,
    repo_version => '5.x',
  }

  elasticsearch::instance { 'es-01':
    config  => {
      'network.host' => '0.0.0.0',
    },
  }

  es_instance_conn_validator { 'es-01':
    server  => 'localhost',
    port    => '9200',
    require => Elasticsearch::Instance['es-01'],
  }

  class { 'kibana':
    manage_repo => false,
    config      => {
      'server.port' => '8080',
      'server.host' => '0.0.0.0',
    },
    require     => Es_Instance_Conn_Validator['es-01'],
  }

}
