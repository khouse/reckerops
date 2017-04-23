require 'serverspec'

set :backend, :exec

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
