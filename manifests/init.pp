# == Class: profile_elasticsearch
#
# Full description of class profile_elasticsearch here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class profile_elasticsearch
{
  class { '::profile_elasticsearch::install': }
  -> class { '::profile_elasticsearch::config': }
  ~> class { '::profile_elasticsearch::service': }
  -> Class['::profile_elasticsearch']
}
