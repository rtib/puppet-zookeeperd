require 'spec_helper'

describe 'zookeeperd' do
  on_supported_os(facterversion: '2.4').each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('zookeeperd') }
      it { is_expected.to contain_class('zookeeperd::install').that_comes_before('Class[zookeeperd::config]') }
      it { is_expected.to contain_class('zookeeperd::config') }
      it { is_expected.to contain_class('zookeeperd::service').that_subscribes_to('Class[zookeeperd::config]') }
    end
  end
end
