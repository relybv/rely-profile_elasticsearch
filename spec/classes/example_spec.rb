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
          it { is_expected.to contain_class('logstash') }

          it { is_expected.to contain_elasticsearch__instance('es-01') }

          it { is_expected.to contain_apt__source('elasticrepo') }
          it { is_expected.to contain_es_instance_conn_validator('es-01') }

          it { is_expected.to contain_Exec('wait for kibana') }

          it { is_expected.to contain_Logstash__configfile('inputs') }
          it { is_expected.to contain_Logstash__configfile('filters') }
          it { is_expected.to contain_Logstash__configfile('outputs') }

        end
      end
    end
  end
end
