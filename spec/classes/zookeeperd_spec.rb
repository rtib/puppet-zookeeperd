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
    end
  end
end
