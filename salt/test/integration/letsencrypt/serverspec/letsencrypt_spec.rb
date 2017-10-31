require 'serverspec'

set :backend, :exec

describe 'certbot' do
  it 'should be installed' do
    expect(package('certbot')).to be_installed
  end

  it 'should be executable' do
    expect(command('certbot -v').exit_status).to eq 0
  end
end
