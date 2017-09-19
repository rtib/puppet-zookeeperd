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
) {
  contain zookeeperd::install
  contain zookeeperd::config
  contain zookeeperd::service

  Class['zookeeperd::install']
  -> Class['zookeeperd::config']
  ~> Class['zookeeperd::service']
}
