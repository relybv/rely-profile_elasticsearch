if ENV['BEAKER'] == 'true'
  # running in BEAKER test environment
  require 'spec_helper_acceptance'
else
  # running in non BEAKER environment
  require 'serverspec'
  set :backend, :exec
end

describe 'profile_elasticsearch class' do

  context 'default parameters' do
    if ENV['BEAKER'] == 'true'
      # Using puppet_apply as a helper
      it 'should work idempotently with no errors' do
        pp = <<-EOS
        class { 'profile_elasticsearch': }
        EOS

        # Run it and test for errors
        apply_manifest(pp, :catch_failures => true)
      end
    end

    describe package('elasticsearch') do
      it { is_expected.to be_installed }
    end

    describe service('elasticsearch-es-01') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe port(9200) do
      it { should be_listening }
    end

    describe package('kibana') do
      it { is_expected.to be_installed }
    end

    describe service('kibana') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe port(8080) do
      it { should be_listening }
    end

    describe package('logstash') do
      it { is_expected.to be_installed }
    end

    describe service('logstash') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

  end
end
