require 'serverspec'

set :backend, :exec

describe 'ssh' do
  it 'should be installed' do
    expect(package('openssh-server')).to be_installed
  end

  it 'should be running' do
    expect(service('sshd')).to be_running
  end

  it 'should be listening' do
    expect(port(22)).to be_listening
  end
end
