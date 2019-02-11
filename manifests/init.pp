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
# @param manage_service enable puppet to manage the zookeeper serivce
# @param service_name name of the service to control
# @param service_enabled enable service at boot time
# @param service_running ensure running of the service
# @param ensamble name of the ensamble
# @param enable_autoconfig enable puppet to manage cluster configuration
# @param nodes list of nodes, if autoconfiguration disable
# @param myid node id of zookeeper instance
# @param nodename fqdn of this node
class zookeeperd (
  Enum['present', 'absent']   $ensure,
  Boolean                     $manage_packages,
  Array[String]               $package_names,
  Stdlib::Absolutepath        $data_dir,
  Variant[Integer,String]     $user,
  Variant[Integer,String]     $group,
  Stdlib::Absolutepath        $cfg_path,
  # zoo.cfg
  Hash[String, Scalar]        $config,
  # service management
  Boolean                     $manage_service,
  String                      $service_name,
  Boolean                     $service_enabled,
  Boolean                     $service_running,
  # cluster configuration parameters
  Boolean                     $enable_autoconfig,
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
