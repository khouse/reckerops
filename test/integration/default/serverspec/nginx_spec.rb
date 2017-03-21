require 'serverspec'

set :backend, :exec

describe package('nginx') do
  it { should be_installed }
end

describe service('nginx') do
  it { should be_running }
  it { should be_enabled }
end

describe file('/etc/nginx/nginx.conf') do
  it { should be_file }
  it 'should be valid' do
    expect(command('nginx -t').exit_status).to eq(0)
  end
end

describe host('localhost') do
  it { should be_resolvable }
  it 'should serve default web page' do
    expect(command('curl --silent localhost').stdout).to match('ReckerOps')
  end
end
