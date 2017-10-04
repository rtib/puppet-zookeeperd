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

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it do
        is_expected.to contain_concat__fragment(
          "zoo.cfg node entry for debian-8-x86.example.org"
        ).with(
          'content' => %r{server.2886795266=debian-8-x86.example.org:2888:3888}
        )
      end
    end
  end
end
