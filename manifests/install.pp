# == Class profile_elasticsearch::install
#
# This class is called from profile_elasticsearch for install.
#
class profile_elasticsearch::install {
  # prevent direct use of subclass
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  class {'elasticsearch':
    manage_repos   => true,
    manage_service => true,
#    version        => '1.2.2',
  }

  class { 'grafana':
    install_method => 'package',
    package_source => 'https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana_4.1.2-1486989747_amd64.deb',
    cfg            => {
      app_mode => 'production',
      server   => {
        http_port     => 8080,
      },
      database => {
        type     => 'sqlite3',
        host     => '127.0.0.1:3306',
        name     => 'grafana',
        user     => 'root',
        password => '',
      },
      users    => {
        allow_sign_up => false,
      },
    },
  }

  grafana_datasource { 'elasticsearch':
    grafana_url      => 'http://localhost:8080',
    grafana_user     => 'admin',
    grafana_password => 'admin',
    type             => 'elasticsearch',
    url              => 'http://localhost:8086',
    database         => 'telegraf',
    access_mode      => 'proxy',
    is_default       => true,
    require          => Class['elasticsearch'],
  }
  grafana_datasource { 'internal_elasticsearch':
    grafana_url      => 'http://localhost:8080',
    grafana_user     => 'admin',
    grafana_password => 'admin',
    type             => 'elasticsearch',
    url              => 'http://localhost:8086',
    database         => '_internal',
    access_mode      => 'proxy',
    require          => Class['elasticsearch'],
  }

  grafana_dashboard { 'Telegraf Windows Instances':
    grafana_url      => 'http://localhost:8080',
    grafana_user     => 'admin',
    grafana_password => 'admin',
    content          => template('profile_elasticsearch/windows-dash.json.erb'),
    require          => [ Class['elasticsearch'], Grafana_datasource['elasticsearch'],],
  }
  grafana_dashboard { 'HAproxy metrics':
    grafana_url      => 'http://localhost:8080',
    grafana_user     => 'admin',
    grafana_password => 'admin',
    content          => template('profile_elasticsearch/haproxy-dash.json.erb'),
    require          => [ Class['elasticsearch'], Grafana_datasource['elasticsearch'],],
  }
  grafana_dashboard { 'Telegraf system overview':
    grafana_url      => 'http://localhost:8080',
    grafana_user     => 'admin',
    grafana_password => 'admin',
    content          => template('profile_elasticsearch/telegraf-dash.json.erb'),
    require          => [ Class['elasticsearch'], Grafana_datasource['elasticsearch'],],
  }
  grafana_dashboard { 'InfluxDB Metrics':
    grafana_url      => 'http://localhost:8080',
    grafana_user     => 'admin',
    grafana_password => 'admin',
    content          => template('profile_elasticsearch/elasticsearch-dash.json.erb'),
    require          => [ Class['elasticsearch'], Grafana_datasource['internal_elasticsearch'],],
  }
  grafana_dashboard { 'Apache Overview':
    grafana_url      => 'http://localhost:8080',
    grafana_user     => 'admin',
    grafana_password => 'admin',
    content          => template('profile_elasticsearch/apache-dash.json.erb'),
    require          => [ Class['elasticsearch'], Grafana_datasource['internal_elasticsearch'],],
  }
  grafana_dashboard { 'MySQL Metrics':
    grafana_url      => 'http://localhost:8080',
    grafana_user     => 'admin',
    grafana_password => 'admin',
    content          => template('profile_elasticsearch/mysql-dash.json.erb'),
    require          => [ Class['elasticsearch'], Grafana_datasource['internal_elasticsearch'],],
  }

}
