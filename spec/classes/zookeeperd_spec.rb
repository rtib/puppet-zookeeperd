require 'spec_helper'

describe 'zookeeperd' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      describe 'module structure' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('zookeeperd') }
        it { is_expected.to contain_class('zookeeperd::install').that_comes_before('Class[zookeeperd::config]') }
        it { is_expected.to contain_class('zookeeperd::config') }
        it { is_expected.to contain_class('zookeeperd::service').that_subscribes_to('Class[zookeeperd::config]') }
      end

      describe 'zookeeperd::install' do
        it { is_expected.to contain_package('zookeeper') }
        it { is_expected.to contain_package('zookeeper-bin') }
        it { is_expected.to contain_package('zookeeperd') }
      end

      describe 'zookeeperd::config' do
        it {
          is_expected.to contain_file('/var/lib/zookeeper')
            .with(
              'ensure' => 'directory',
            )
        }
        it {
          is_expected.to contain_file('/var/lib/zookeeper/version-2')
            .with(
              'ensure' => 'directory',
            )
        }
        it {
          is_expected.to contain_file('/var/lib/zookeeper/myid')
            .with(
              'ensure' => 'file',
            )
        }
        it do
          is_expected.to contain_concat__fragment('zoo.cfg head')
            .with_content(%r{tickTime=2000})
            .with_content(%r{initLimit=10})
            .with_content(%r{syncLimit=5})
            .with_content(%r{dataDir=/var/lib/zookeeper})
            .with_content(%r{maxClientCnxns=500})
            .with_content(%r{clientPort=2181})
            .with_content(%r{forceSync=yes})
        end
      end
    end
  end
end
