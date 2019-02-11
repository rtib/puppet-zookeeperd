require 'spec_helper_acceptance'

describe 'zookeeperd class' do
  it 'class should apply successfully on first shot' do
    manifest = %(
      class { 'zookeeperd':
        ensamble => 'Docker test cluster',
      }
    )
    # first apply should not log any error message
    apply_manifest(manifest, catch_failures: true) do |res|
      expect(res.stderr).not_to match(%r{error})
    end
    # second apply should not change anything
    apply_manifest(manifest, catch_failures: true) do |res|
      expect(res.stderr).not_to match(%r{error})
      expect(res.exit_code).to be_zero
    end
  end # it 'class should apply successfully on first shot'
  context 'installation complete' do
    packages = ['zookeeper', 'zookeeper-bin', 'zookeeperd'].freeze
    packages.each do |pkg|
      describe package(pkg) do
        it { is_expected.to be_installed }
      end
    end
  end # context 'installation complete'
  context 'configuration' do
    describe file('/var/lib/zookeeper/myid') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match %r{\d+} }
    end
    describe file('/var/lib/zookeeper/version-2') do
      it do
        is_expected.to be_directory
        is_expected.to be_owned_by 'zookeeper'
        is_expected.to be_grouped_into 'zookeeper'
        is_expected.to be_mode 755
      end
    end
    describe file('/etc/zookeeper/conf/zoo.cfg') do
      it { is_expected.to be_file }
      its(:content) do
        is_expected.to match %r{tickTime=2000}
        is_expected.to match %r{initLimit=10}
        is_expected.to match %r{syncLimit=5}
        is_expected.to match %r{dataDir=/var/lib/zookeeper}
        is_expected.to match %r{maxClientCnxns=500}
        is_expected.to match %r{clientPort=2181}
        is_expected.to match %r{forceSync=yes}
      end
    end
  end
  context 'service control' do
    describe service('zookeeper') do
      it do
        is_expected.to be_enabled
        is_expected.to be_running
      end
    end
    describe process('java'), retry: 10, retry_wait: 5 do
      it { is_expected.to be_running }
      its(:user) { is_expected.to eq 'zookeeper' }
      its(:args) { is_expected.to match %r{org.apache.zookeeper.server.quorum.QuorumPeerMain} }
    end
  end
  context 'client port listening' do
    describe port(2181), retry: 10, retry_wait: 5 do
      it { is_expected.to be_listening.with('tcp') }
    end
  end
  # TODO: add tests here!
end # describe 'zookeeperd class'
