# zookeeperd::install
#
# Internal class do not use of its own.
#
# @summary control the configuration of the node
#
class zookeeperd::install {
  if $zookeeperd::manage_packages {
    package { $zookeeperd::package_names:
      ensure => $zookeeperd::ensure,
    }
  }
}
