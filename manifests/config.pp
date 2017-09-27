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
    ensure  => file,
    content => "${zookeeperd::myid}",
    owner   => $zookeeperd::user,
    group   => $zookeeperd::group,
    mode    => '0755',
  }
  concat { $zookeeperd::cfg_path:
    ensure         => $zookeeperd::ensure,
    order          => numeric,
    ensure_newline => true,
  }
  concat::fragment { 'zoo.cfg head':
    target  => $zookeeperd::cfg_path,
    content => epp('zookeeperd/zoo.cfg.head.epp'),
    order   => 1,
  }
  if $zookeeperd::enable_autoconfig {
    @@zookeeperd::node{ "${zookeeperd::ensamble} node ${zookeeperd::ip}":
      ensamble => $zookeeperd::ensamble,
      cfgtgt   => $zookeeperd::cfg_path,
      nodeid   => $zookeeperd::myid,
      nodename => $zookeeperd::nodename,
    }
  } else {
    $zookeeperd::nodes.each |String $name, Hash $params| {
      zookeeperd::node{ $name:
        * => $params,
      }
    }
  }
}
