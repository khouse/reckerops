require 'serverspec'

set :backend, :exec

docker_package = {
  'redhat' => 'docker'
}.fetch(os[:family], 'docker-engine')

describe package(docker_package) do
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
