# zookeeperd
#
# Puppet module to configure the nodes of an zookeeper ensamble.
#
# @summary Main class of puppet module configuring nodes of an zookeeper ensamble.
#
# @example
#   include zookeeperd
#
# @example
#   zookeeperd::ensamble: 'Awesamly important, dynamically growing zookeeper cluster'
#   zookeeperd::enable_autoconfig: true
#
# @param ensure add or remove this node from ensamble
# @param manage_packages enable puppet to manage package installation
# @param package_names list of packages to be installed
# @param data_dir path to the data directory of zookeeper
# @param user username of zookeeper service
# @param group groupname of zookeeper service
# @param cfg_path path to configuration directory
# @param config parameter to generate zoo.cfg configration file
# @param maintenance_service 
#   establish the systemd units for maintenance cleanup service and its timer
# @param maintenance_schedule
#   array for timer wallclocks to schedule maintenance clienups, refer to
#   [systemd.time(7)#Parsing Timestamps](https://www.freedesktop.org/software/systemd/man/systemd.time.html#Parsing%20Timestamps) for details on the items of this array
# @param maintenance_snapretention
#   configure the number of snapshots to be retained during cleanup
# @param manage_service enable puppet to manage the zookeeper serivce
# @param service_name name of the service to control
# @param service_enabled enable service at boot time
# @param service_running ensure running of the service
# @param ensamble name of the ensamble
# @param nodes list of nodes, if autoconfiguration disable
# @param myid node id of zookeeper instance
# @param nodename fqdn of this node
class zookeeperd (
  Enum['present', 'absent']   $ensure = 'present',
  Boolean                     $manage_packages = true,
  Array[String]               $package_names = [],
  Stdlib::Absolutepath        $data_dir = '',
  Variant[Integer,String]     $user = 'zookeeper',
  Variant[Integer,String]     $group = 'zookeeper',
  Stdlib::Absolutepath        $cfg_path = '',
  # zoo.cfg
  Hash[String, Scalar]        $config = {},
  # maintenance service
  Boolean                     $maintenance_service = true,
  Array[String]               $maintenance_schedule = [],
  Integer                     $maintenance_snapretention = 3,
  # service management
  Boolean                     $manage_service = true,
  String                      $service_name = 'zookeeper',
  Boolean                     $service_enabled = true,
  Boolean                     $service_running = true,
  # cluster configuration parameters
  Optional[String]            $ensamble = undef,
  Hash                        $nodes = {},
  # Parameter having facts default
  Integer                     $myid = $facts['zookeeperd']['myid'],
  String                      $nodename = $facts['networking']['fqdn'],
) {
  contain zookeeperd::install
  contain zookeeperd::config
  contain zookeeperd::service

  Class['zookeeperd::install']
  -> Class['zookeeperd::config']
  ~> Class['zookeeperd::service']
}
