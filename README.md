
# zookeeperd

GitHub: [![GitHub issues](https://img.shields.io/github/issues/rtib/puppet-zookeeperd.svg)](https://github.com/rtib/puppet-zookeeperd/issues) [![GitHub license](https://img.shields.io/github/license/rtib/puppet-zookeeperd.svg)](https://github.com/rtib/puppet-zookeeperd/blob/master/LICENSE) [![GitHub tag](https://img.shields.io/github/tag/rtib/puppet-zookeeperd.svg)](https://github.com/rtib/puppet-zookeeperd/releases)

Workflows: [![CI](https://github.com/rtib/puppet-zookeeperd/actions/workflows/ci.yaml/badge.svg?branch=main)](https://github.com/rtib/puppet-zookeeperd/actions/workflows/ci.yaml) [![release](https://github.com/rtib/puppet-zookeeperd/actions/workflows/release.yaml/badge.svg?branch=main)](https://github.com/rtib/puppet-zookeeperd/actions/workflows/release.yaml)

Puppet Forge: [![Puppet Forge](https://img.shields.io/puppetforge/v/trepasi/zookeeperd.svg)](https://forge.puppet.com/trepasi/zookeeperd) [![Puppet Forge](https://img.shields.io/puppetforge/f/trepasi/zookeeperd.svg)](https://forge.puppet.com/trepasi/zookeeperd) [![Puppet Forge](https://img.shields.io/puppetforge/dt/trepasi/zookeeperd.svg)](https://forge.puppet.com/trepasi/zookeeperd)

#### Table of Contents

- [zookeeperd](#zookeeperd)
      - [Table of Contents](#table-of-contents)
  - [Description](#description)
  - [Setup](#setup)
    - [Setup Requirements](#setup-requirements)
    - [Beginning with zookeeperd](#beginning-with-zookeeperd)
  - [Usage](#usage)
    - [Automatic cluster configuration](#automatic-cluster-configuration)
    - [Manual configuration](#manual-configuration)
    - [Zookeeper maintenance](#zookeeper-maintenance)
    - [Using zookeeperd fact](#using-zookeeperd-fact)
  - [Configuration](#configuration)
    - [zoo.cfg](#zoocfg)
  - [Reference](#reference)
  - [Limitations](#limitations)
  - [Development](#development)

## Description

Yet another puppet module configuring zookeeper ...

Unique with this module are two features making the usually very painful zookeeper configuration as easy as it can be. First, as all zookeeper nodes need a unique ID to be given, this module provides a custom fact which calculatint a suitable value. Second, all zookeeper nodes need to get the list of all nodes belonging to its ensamble. By making use of puppet's exported resource feature, node definitions are exported and collected to building the server list. Utilizing both features will automate zookeeper configuration and eliminate the node ID and the list of servers from your puppet manifests and hiera.

## Setup

### Setup Requirements

It is presumed that zookeeper packages are available on your system via regular package management. This module won't configure any package management repositories.

Pluginsync needs to be enabled on your puppet deployment in order to get the custom fact working.

Stored config needs to be enabled on your puppetmaster infrastructure in order to get autoconfiguration feature working. Also, it is strongly recommended to use PuppetDB and consider it as a critical part of your configuration management system. Be aware, that manipulation, inconsistency and data loss from your PuppetDB may cause this module to disrupt your zookeeper clusters.

### Beginning with zookeeperd  

Install the module and its dependencies to your environment. Include the module to your manifests. You may utilize hiera to hold configuration parameter. The module carries most of its default values using hiera in module, which also serve as an example.

## Usage

### Automatic cluster configuration

This module enables to automatically create the configurations of zookeeper instances belonging to the same ensamble. To do so, enable autoconfiguration and set an ensamble name on all nodes of the cluster.

```puppet
class{ zookeeperd:
  ensamble          => 'Awesamly easy way to your zookeeper cluster',
  enable_autoconfig => true,
}
````

This will install zookeeper to all nodes this manifest applies to and configure all instances having the same ensamble name to one cluster. Note, that puppet needs at least two runs to get the configuration ready: the first run will export the node definitions, the second will collect all nodes. This is done by exporting ```zookeeperd::node``` resources tagged with their ensamble and collecting the same resources having the matching ensamble tag. Each ```zookeeperd::node``` resource will create one ```server``` entry in the zoo.cfg configuration telling zookeeper the list of nodes within the cluster.

### Manual configuration

If you don't trust your PuppetDB, or does not want stored configs on your PupppetMaster, you may add pass the list of nodes to the module through nodes parameter.

```puppet
class{ zookeeperd:
  myid  => $id_of_this_node,
  nodes => {
    'first' => {
      nodeid => 1,
      nodename => 'first.zk.example.org',
    },
    'second' => {
      nodeid => 2,
      nodename => 'first.zk.example.org',
    }
  }
}
````

### Zookeeper maintenance

As zookeeper needs maintenance to cleanup logs and snapshots this module provides a systemd service unit invoking the cleanup and a timer unit scheduling it. You may or may not like zookeepers internal maintenance scheduler, which you can configure via ```zookeeperd::config```.

By default, this module will create a systemd service unit called ```zookeeper-cleanup.service``` which does the maintenance and a timer unit ```zookeeper-cleanup.timer``` triggering a previous on a schedule.

### Using zookeeperd fact

The module provides a custom fact which calculates a unique ID for all nodes. This fact is available ```$facts['zookeeperd']['myid']```. The myid parameter of the module defaults to this value. The value is calculated from the IP address (```$facts['networking']['ip]```) of the node by converting it to a 32 bit integer.

Zookeeper documentation, however, states myid must between 1..255, the software itself is treating this as unsigned long, and it is not used for any logic nor arithmetic.

## Configuration

### zoo.cfg

The main configuration file of zookeeper, the zoo.cfg is created by taking key-value pairs from ```zookeeperd::config``` hash. The module proves default values with the minimum parameters needed for zookeeper.

## Reference

The module code is documented using puppet-strings. Visit https://rtib.github.io/puppet-zookeeperd/ to access detailed code documentation.

## Limitations

This is where you list OS compatibility, version compatibility, etc. If there are Known Issues, you might want to include them under their own heading here.

## Development

Puppet modules on the Puppet Forge are open projects, and community contributions are essential for keeping them great. Please follow the usual guidelines when contributing changes.

1. fork the repository on GitHub
2. make your improvements, preferably to a feature branch
3. rebase your changes to the head of the master branch
4. squash your changes into a single commit
5. file a pull request and check the result of Travis-CI tests
