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
    manage_repo  => true,
    repo_version => '5.x',
  }

  elasticsearch::instance { 'es-01':
    config => {
      'network.host' => '0.0.0.0',
    },
  }

  class { 'kibana':
    config => {
      'server.port' => '8080',
      'server.host' => '0.0.0.0',
    },
  }

}
