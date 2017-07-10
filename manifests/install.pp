# == Class profile_elasticsearch::install
#
# This class is called from profile_elasticsearch for install.
#
class profile_elasticsearch::install {
  # prevent direct use of subclass
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  Class['apt::update'] -> Package['elasticsearch']
  Class['apt::update'] -> Package['kibana']
  Class['apt::update'] -> Package['logstash']

  ensure_resource('apt::source', 'elasticrepo', {'ensure' => 'present', 'location' => 'https://artifacts.elastic.co/packages/5.x/apt', 'release' => 'stable', 'repos' => 'main', 'key' => { 'id' => '46095ACC8548582C1A2699A9D27D666CD88E42B4', 'source' => 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',} })

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

  class { 'logstash':
    manage_repo => false,
  }

  class { 'kibana':
    manage_repo => false,
    config      => {
      'server.port'   => '8080',
      'server.host'   => '0.0.0.0',
      'logging.quiet' => true,
    },
    require     => Es_Instance_Conn_Validator['es-01'],
  }

}
