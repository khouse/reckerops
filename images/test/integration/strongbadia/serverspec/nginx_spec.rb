require 'serverspec'

set :backend, :exec

describe 'nginx' do
  it 'should be installed' do
    expect(package('nginx')).to be_installed
  end

  it 'should be running' do
    expect(service('nginx')).to be_running
  end

  it 'should be listening' do
    expect(port(80)).to be_listening
  end

  it 'should be valid' do
    expect(command('nginx -t').exit_status).to eq 0
  end

  it 'should be working' do
    cmd = command('curl -L http://127.0.0.1')
    expect(cmd.stdout).to match(/ReckerOps/)
    expect(cmd.exit_status).to eq 0
  end
end
