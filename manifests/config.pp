# == Class profile_elasticsearch::config
#
# This class is called from profile_elasticsearch for service config.
#
class profile_elasticsearch::config {
  # prevent direct use of subclass
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  logstash::configfile { 'inputs':
    content => template('profile_elasticsearch/logstash/input.conf.erb'),
  }

  logstash::configfile { 'filters':
    content => template('profile_elasticsearch/logstash/filter.conf.erb'),
  }

  logstash::configfile { 'outputs':
    content => template('profile_elasticsearch/logstash/output.conf.erb'),
  }

}
