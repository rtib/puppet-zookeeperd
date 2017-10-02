# zookeeperd::node
#
# A node definition to be added as server line in zoo.cfg file.
# One may define the nodes of an zookeeper ensamble by instanciating this resource.
# The module itself is implementing a factory to create nodes to all keys added to
# zookeeperd::nodes hash.
# This resource is also used with autoconfiguration, which exports this resource and
# collect all exported nodes of the same ensamble.
#
# @summary A short summary of the purpose of this defined type.
#
# @example
#   zookeeperd::node { 'first node of this cluster':
#     nodeid   => 1,
#     nodename => 'first.zk.example.org',
#   }
#   zookeeperd::node { 'second node of this cluster':
#     nodeid   => 2,
#     nodename => 'second.zk.example.org',
#   }
#
# @param nodeid node id (myid) of the zookeeper node to be added to this configuration
# @param nodename fqdn or IP address of the node to be added
# @param ensure ensure meta-parameter to add or remove this node
# @param cfgtgt path to the configuration file to which this server should be added
# @param ensamble name of the ensamble this node belongs to (used with autoconfig)
# @param leaderport leader port parameter of the server
# @param electionport port used for leader election
define zookeeperd::node(
  Integer                   $nodeid,
  String                    $nodename,
  Enum['present', 'absent'] $ensure = 'present',
  String                    $cfgtgt = $zookeeperd::cfg_path,
  Optional[String]          $ensamble = undef,
  Integer                   $leaderport = 2888,
  Integer                   $electionport = 3888,
) {
  if !defined(Concat::Fragment["zoo.cfg node entry for ${nodename}"]) and $ensure == 'present' {
    concat::fragment { "zoo.cfg node entry for ${nodename}":
    target  => $cfgtgt,
    content => "server.${nodeid}=${nodename}:${leaderport}:${electionport}",
    order   => 10,
    }
  }
}
