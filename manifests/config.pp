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
  if $zookeeperd::ensamble =~ String {
    @@zookeeperd::node{ "${zookeeperd::ensamble} node ${zookeeperd::nodename}":
      ensure   => $zookeeperd::ensure,
      ensamble => $zookeeperd::ensamble,
      cfgtgt   => $zookeeperd::cfg_path,
      nodeid   => $zookeeperd::myid,
      nodename => $zookeeperd::nodename,
    }
    Zookeeperd::Node <<| ensamble == $zookeeperd::ensamble and ensure == 'present' |>>
  }

  $zookeeperd::nodes.each |String $name, Hash $params| {
    zookeeperd::node{ $name:
      * => $params,
    }
  }

  $unit_ensure = [$zookeeperd::ensure, $zookeeperd::maintenance_service] ? {
    ['present', true] => 'present',
    default           => 'absent',
  }
  $timer_ensure = [$zookeeperd::ensure, $zookeeperd::maintenance_service, $zookeeperd::maintenance_schedule.length > 0] ? {
    ['present', true, true] => 'present',
    default                 => 'absent',
  }

  systemd::unit_file{ 'zookeeper-cleanup.service':
    ensure  => $unit_ensure,
    content => epp('zookeeperd/cleanup-service.epp')
  }

  systemd::unit_file{ 'zookeeper-cleanup.timer':
    ensure  => $timer_ensure,
    content => epp('zookeeperd/cleanup-timer.epp')
  }
}
