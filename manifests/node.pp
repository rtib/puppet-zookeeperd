# zookeeperd::node
#
# A description of what this defined type does
#
# @summary A short summary of the purpose of this defined type.
#
# @example
#   zookeeperd::node { 'namevar': }
define zookeeperd::node(
  String           $cfgtgt,
  Integer          $nodeid,
  String           $nodename,
  Optional[String] $ensamble = undef,
  Integer          $leaderport = 2888,
  Integer          $electionport = 3888,
) {
  if !defined(Concat::Fragment["zoo.cfg node entry for ${nodename}"]) {
    concat::fragment { "zoo.cfg node entry for ${nodename}":
    target  => $cfgtgt,
    content => "server.${nodeid}=${nodename}:${leaderport}:${electionport}",
    order   => 10,
    }
  }
}
