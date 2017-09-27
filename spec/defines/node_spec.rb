require 'spec_helper'

describe 'zookeeperd::node' do
  let(:title) { 'namevar' }
  let(:params) do
    {
      'cfgtgt'   => '/etc/zookeeper/conf/zoo.cfg',
      'nodeid'   => 2_886_795_266,
      'nodename' => 'debian-8-x86.example.org',
    }
  end

  on_supported_os(facterversion: '2.4').each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
