
# zookeeperd
[![Build Status](https://travis-ci.org/rtib/puppet-zookeeperd.svg?branch=master)](https://travis-ci.org/rtib/puppet-zookeeperd)
[![GitHub issues](https://img.shields.io/github/issues/rtib/puppet-zookeeperd.svg)](https://github.com/rtib/puppet-zookeeperd/issues)
[![GitHub license](https://img.shields.io/badge/license-Apache%202-blue.svg)](https://raw.githubusercontent.com/rtib/puppet-zookeeperd/master/LICENSE)

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with zookeeperd](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with zookeeperd](#beginning-with-zookeeperd)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Description

Yet another puppet module configuring zookeeper ...

Unique with this module are two features making zookeeper configuration usually very painful. First, all zookeeper nodes need a unique ID to be given. This module provide a custom fact which calculates a suitable ID for every node. Second, all zookeeper nodes need to get the list of all nodes belonging to its ensamble. This module enables autoconfiguration by exporting node definitions of every node and building the server list for zookeeper by collecting those exported node definitions. Utilizing both features will automate zookeeper configuration by taking away the most painful parts and eliminate the node ID and the  list of servers from your puppet manifests and hiera.

## Setup

### Setup Requirements

It is presumed that zookeeper packages are available on your system via regular package management.  This module won't configure any package management repositories.

Pluginsync needs to be enabled on your puppet deployment in order to get the custom fact working.

Stored config needs to be enabled on your puppetmaster infrastructure in order to get autoconfiguration feature working. Also, it is strongly recommended to use PuppetDB and consider it as a critical part of your configuration management system. Be aware, that manipulation, inconsistency and data loss from your PuppetDB may cause this module to disrupt your zookeeper clusters.

### Beginning with zookeeperd  

Install the module and its dependencies to your environment. Include the module to your manifests. You may utilize hiera to hold configuration parameter. The module carries most of its default values using hiera in module, which also serve as an example.

## Usage

To create a zookeeper cluster, the easies way is, to include the module to your manifest, enable autoconfiguration and set an ensamble name  on all nodes of the cluster.

```puppet
class{ zookeeperd:
  ensamble          => 'Awesamly easy way to your zookeeper cluster',
  enable_autoconfig => true,
}
````

The above example will install zookeeper to all nodes this manifest applies to and configure all instances having the same ensamble name to one cluster. Note, that puppet needs at least two runs to get the configuration ready: the first run will export the node definitions, the second will collect all nodes.

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

### Using zookeeperd fact
The module provides a custom fact which calculates a unique ID for all nodes. This fact is available ```$facts['zookeeperd']['myid']```. The myid parameter of the module defaults to this value. The value is calculated from the IP address (```$facts['networking']['ip]```) of the node by converting it to a 32 bit integer.

Zookeeper documentation, however, states myid must between 1..255, the software itself is treating this as unsigned long, and it is not used for any logic nor arithmetic.

## Reference

The module code is documented using puppet-strings. Visit https://rtib.github.io/puppet-zookeeperd/ to access detailed code documentation.

## Limitations

This is where you list OS compatibility, version compatibility, etc. If there are Known Issues, you might want to include them under their own heading here.

## Development

Puppet modules on the Puppet Forge are open projects, and community contributions are essential for keeping them great. Please follow the usual guidelines when contributing changes.
1. fork the repository on GitHub
1. make your improvements, preferably to a feature branch
1. rebase your changes to the head of the master branch
1. squash your changes into a single commit
1. file a pull request and check the result of Travis-CI tests

## Donate

If you like this project feel free to support via Bitcoin
[![BitCoin Wallet 3Cmcvt2zZ4owgW6SBUMXHkNvJu4mq6GoNu ](https://github.com/rtib/puppet-zookeeperd/raw/master/donate.png)](bitcoin:3Cmcvt2zZ4owgW6SBUMXHkNvJu4mq6GoNu?label=donate%3A%20PuppetForge%20trepasi%20zookeeperd)
