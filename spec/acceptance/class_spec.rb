require 'spec_helper_acceptance'

describe 'zookeeperd class' do
  it 'class should apply successfully on first shot' do
    manifest = %{
      class { 'zookeeperd':
      }
    }
    # first apply should not log any error message
    apply_manifest(manifest, :catch_failures => true) do |res|
      expect(res.stderr).not_to match(/error/i)
    end
    # second apply should not change anything
    apply_manifest(manifest, :catch_failures => true) do |res|
      expect(res.stderr).not_to match(/error/i)
      expect(res.exit_code).to be_zero
    end
  end # it 'class should apply successfully on first shot'
  # ToDo: add tests here!
end # describe 'zookeeperd class'
