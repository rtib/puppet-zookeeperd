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
  $timer_ensure = [$zookeeperd::ensure, $zookeeperd::maintenance_service, $zookeeperd::maintenance_schedule.length > 0] ? {
    ['present', true, true] => 'running',
    default                 => 'stopped',
  }
  $timer_enable = [$zookeeperd::ensure, $zookeeperd::maintenance_service, $zookeeperd::maintenance_schedule.length > 0] ? {
    ['present', true, true] => true,
    default                 => false,
  }

  service{ 'zookeeper-cleanup.timer':
    ensure => $timer_ensure,
    enable => $timer_enable,
  }
}
