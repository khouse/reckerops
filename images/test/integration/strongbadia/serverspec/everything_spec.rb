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

describe 'python' do
  it 'should be installed' do
    expect(package('python')).to be_installed
  end

  it 'should be executable' do
    expect(command('python --version').exit_status).to eq 0
    expect(command('pip --version').exit_status).to eq 0
  end
end

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
    expect(file('/reckerops/docker-compose.yml')).to exist
  end
end

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

describe 'datadog' do
  it 'should be installed' do
    expect(package('datadog-agent')).to be_installed
  end

  it 'should be running' do
    expect(service('datadog-agent')).to be_running
  end

  it 'should be configured' do
    f = file('/etc/dd-agent/datadog.conf')
    expect(f).to exist
    tags = /tags: machine:strongbadia website:test.alexrecker.com/
    expect(f.content).to match(tags)
  end
end

describe 'certbot' do
  it 'should be installed' do
    expect(package('certbot')).to be_installed
  end

  it 'should be executable' do
    expect(command('certbot --version').exit_status).to eq 0
  end

  it 'should be scheduled' do
    expect(file('/reckerops/certbot-renew.sh')).to exist
    expect(cron).to have_entry '0 1 * * sun /reckerops/certbot-renew.sh'
  end
end

describe 'user' do
  me = user('alex')

  it 'should be a sudoer' do
    expect(me).to belong_to_group('sudo')
  end

  it 'should have a home directory' do
    expect(me).to have_home_directory('/home/alex')
  end

  it 'should have a shell' do
    expect(me).to have_login_shell('/bin/bash')
  end
end
