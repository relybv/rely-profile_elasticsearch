require 'spec_helper'

describe 'profile_elasticsearch' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts.merge({
            :concat_basedir => "/foo"
          })
        end

        context "profile_elasticsearch class without any parameters" do
          let(:params) {{ }}

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('profile_elasticsearch') }
          it { is_expected.to contain_class('profile_elasticsearch::install') }
          it { is_expected.to contain_class('profile_elasticsearch::config') }
          it { is_expected.to contain_class('profile_elasticsearch::service') }
          it { is_expected.to contain_class('elasticsearch') }
          it { is_expected.to contain_class('kibana') }

          it { is_expected.to contain_elasticsearch__instance('es-01') }

        end
      end
    end
  end
end
