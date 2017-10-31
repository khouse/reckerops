require 'serverspec'

set :backend, :exec

describe 'docker' do
  it 'should be installed' do
    expect(package('docker-ce')).to be_installed
  end

  it 'should be running' do
    expect(service('docker')).to be_running
  end

  it 'should be enabled' do
    expect(service('docker')).to be_enabled
  end

  it 'should be executable' do
    expect(command('docker -v').exit_status).to eq 0
  end
end
