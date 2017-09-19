# zookeeperd::install
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include zookeeperd::install
class zookeeperd::install {
  if $zookeeperd::manage_packages {
    package { $zookeeperd::package_names:
      ensure => $zookeeperd::ensure,
    }
  }
}
