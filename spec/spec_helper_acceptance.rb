require 'beaker-rspec'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'

run_puppet_install_helper
install_ca_certs unless ENV['PUPPET_INSTALL_TYPE'].match?(%r{pe}i)
install_module_on(hosts)
install_module_dependencies_on(hosts)

UNSUPPORTED_PLATFORMS = ['aix', 'Solaris', 'BSD'].freeze

RSpec.configure do |c|
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
  end
end

shared_examples 'an idempotent resource' do
  it 'apply with no errors' do
    apply_manifest(manifest, catch_failures: true)
  end

  it 'apply a second time without changes', :skip_pup_5016 do
    apply_manifest(manifest, catch_changes: true)
  end
end
