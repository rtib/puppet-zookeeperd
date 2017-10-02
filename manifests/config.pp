# zookeeperd::config
#
# Internal class do not use of its own.
#
# @summary control the configuration of the node
#
class zookeeperd::config {
  file { [$zookeeperd::data_dir, "${zookeeperd::data_dir}/version-2"]:
    ensure => directory,
    owner  => $zookeeperd::user,
    group  => $zookeeperd::group,
    mode   => '0755',
  }
  file { "${zookeeperd::data_dir}/myid":
    ensure  => file,
    # lint:ignore:only_variable_string
    # that's the prefered way to cast, according to https://docs.puppet.com/puppet/5.2/lang_data_number.html#converting-numbers-to-strings
    content => "${zookeeperd::myid}",
    # lint:endignore
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
      ensure   => $zookeeperd::ensure,
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
