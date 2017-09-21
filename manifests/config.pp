# zookeeperd::config
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include zookeeperd::config
class zookeeperd::config {
  file { [$zookeeperd::data_dir, "${zookeeperd::data_dir}/version-2"]:
    ensure => directory,
    owner  => $zookeeperd::user,
    group  => $zookeeperd::group,
    mode   => '0755',
  }
  file { "${zookeeperd::data_dir}/myid":
  ensure => file,
  content => inline_epp()
  }
  concat { $zookeeperd::cfg_path:
    ensure         => $zookeeperd::ensure,
    order          => numeric,
    ensure_newline => true,
  }
  concat::fragment { 'zoo.cfg head':
    ensure => $zookeeperd::ensure,
    content => epp('zookeeperd/zoo.cfg.head.epp'),
    order   => 1,
  }
  @@zookeeper::node{ "${zookeeperd::cluster} node ${zookeeperd::ip}":
  }
}
