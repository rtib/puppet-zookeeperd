# zookeeperd
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include zookeeperd
class zookeeperd (
  Enum['present', 'absent'] $ensure,
  Boolean                   $manage_packages,
  Array[String]             $package_names,
  Stdlib::Absolutepath      $data_dir,
  Variant[Integer,String]   $user,
  Variant[Integer,String]   $group,
  Stdlib::Absolutepath      $cfg_path,
  # zoo.cfg general params
  Integer                  $tick_time,
  Integer                  $init_limit,
  Integer                  $sync_limit,
  Integer                  $max_client_cnxns,
  Integer[1025,65534]      $client_port,
  Boolean                  $force_sync,
  
) {
  contain zookeeperd::install
  contain zookeeperd::config
  contain zookeeperd::service

  Class['zookeeperd::install']
  -> Class['zookeeperd::config']
  ~> Class['zookeeperd::service']
}
