require 'serverspec'

set :backend, :exec

describe 'docker' do
  it 'should be installed' do
    expect(package('docker-engine')).to be_installed
  end

  it 'should be running' do
    expect(service('docker')).to be_running
  end

  it 'should be executable' do
    expect(command('docker -v').exit_status).to eq 0
    expect(command('docker-compose -v').exit_status).to eq 0
  end

  it 'should be configured' do
    expect(file('/reckerops/docker/docker-compose.yml')).to exist
    expect(file('/reckerops/docker/configs')).to be_directory
  end
end
