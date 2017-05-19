# == Class profile_elasticsearch::params
#
# This class is meant to be called from profile_elasticsearch.
# It sets variables according to platform.
#
class profile_elasticsearch::params {
  case $::osfamily {
    'Debian': {
      $package_name = 'profile_elasticsearch'
      $service_name = 'profile_elasticsearch'
    }
    'RedHat', 'Amazon': {
      $package_name = 'profile_elasticsearch'
      $service_name = 'profile_elasticsearch'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
