require 'serverspec'

set :backend, :exec

describe package('nginx') do
  it { should be_installed }
end

describe service('nginx') do
  it { should be_running }
end

describe command('nginx -t -c /etc/nginx/nginx.conf') do
  its(:exit_status) { should eq 0 }
end

describe port(80) do
  it { should be_listening }
end

describe port(443) do
  it { should be_listening }
end

describe host('test.alexrecker.com') do
  its(:ipaddress) { should eq '127.0.0.1' }
  it { should be_reachable }
end

describe command('wget --quiet -O- localhost') do
  its(:stdout) { should match 'ReckerOps' }
  its(:exit_status) { should eq 0 }
end
