# zookeeperd::service
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include zookeeperd::service
class zookeeperd::service {
  if $zookeeperd::manage_service {
    service { $zookeeperd::service_name:
      ensure => $zookeeperd::service_running,
      enable => $zookeeperd::service_enabled,
    }
  }
}
