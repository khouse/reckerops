require 'serverspec'

set :backend, :exec

describe package('docker-engine') do
  it { should be_installed }
end

describe service('docker') do
  it { should be_running }
end

describe command('docker -v') do
  its(:exit_status) { should eq 0 }
end

describe command('docker-compose -v') do
  its(:exit_status) { should eq 0 }
end

describe file('/reckerops/docker-compose.yml') do
  it { should exist }
end