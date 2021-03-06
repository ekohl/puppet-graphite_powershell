# Author::    Liam Bennett (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

# == Class: graphite_powershell
#
# Module to send metrics to graphite from windows
#
# === Requirements/Dependencies
#
# Currently requires the modules puppetlabs/stdlib and puppetlabs/powershell on
# the Puppet Forge in order to validate much of the the provided configuration.
#
# === Parameters
#
# [*server*]
# The graphite server in which to send the configured metrics
#
# [*install_url*]
# The url from which to download the graphite powershell script
#
# [*install_dir*]
# The location in which to install the graphite powershell script
#
# [*port*]
# The port that the graphite server is running on.
#
# [*metric_path*]
# The graphite namespece in which the stats will be sent to
#
# [*metric_send_interval*]
# The time inveral (in seconds) in which to send metrics to the graphite server
#
# [*timezone*]
# The timezone of your graphite server.
#
# [*performance_counters*]
# A list of the performance counters that you want to be sent to graphite.
#
# [*metric_filters*]
# A list of names you want to filter out of the performance counter list
#
# [*verbose_logging*]
# If enabled, will log each of the metrics that were sent to the graphite server.
#
# === Examples
#
# Install with defaults:
#
#  class { 'graphite_powershell':
#    server => 'graphite.mycorp.com'
#  }
#
# Install and just send network counters:
#
#  class { 'graphite_powershell':
#    server               => 'graphite.mycorp.com',
#    performance_counters => [
#      '\Network Interface(*)\Bytes Received/sec',
#      '\Network Interface(*)\Bytes Sent/sec',
#      '\Network Interface(*)\Packets Received Unicast/sec',
#      '\Network Interface(*)\Packets Sent Unicast/sec',
#      '\Network Interface(*)\Packets Received Non-Unicast/sec',
#      '\Network Interface(*)\Packets Sent Non-Unicast/sec',
#    ]
#  }
#
class graphite_powershell (
  String $server,
  Variant[Stdlib::HTTPUrl, Stdlib::HTTPSUrl] $install_url = $graphite_powershell::params::install_url,
  Stdlib::Absolutepath $install_dir                       = $graphite_powershell::params::install_dir,
  Integer $port                                           = $graphite_powershell::params::port,
  String $metric_path                                     = $graphite_powershell::params::metric_path,
  Integer $metric_send_interval                           = $graphite_powershell::params::metric_send_interval,
  String $timezone                                        = $graphite_powershell::params::timezone,
  Array $performance_counters                             = $graphite_powershell::params::performance_counters,
  Array $metric_filters                                   = $graphite_powershell::params::metric_filters,
  Boolean $verbose_logging                                = $graphite_powershell::params::verbose_logging
) inherits graphite_powershell::params {

  if $facts['os']['family'] != 'windows' {
    fail("${facts['os']['family']} not supported")
  }

  contain graphite_powershell::config
  contain graphite_powershell::install
  contain graphite_powershell::service

  Class['graphite_powershell::config']
  -> Class['graphite_powershell::install']
  -> Class['graphite_powershell::service']
}
