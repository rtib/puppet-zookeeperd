# zookeeperd::service
#
# Internal class do not use of its own.
#
# @summary control the configuration of the node
#
class zookeeperd::service {
  if $zookeeperd::manage_service {
    service { $zookeeperd::service_name:
      ensure => $zookeeperd::service_running,
      enable => $zookeeperd::service_enabled,
    }
  }
}
