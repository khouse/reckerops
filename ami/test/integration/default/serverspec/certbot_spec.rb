require 'serverspec'

set :backend, :exec

describe 'certbot' do
  it 'should be installed' do
    expect(package('certbot')).to be_installed
  end

  it 'should be executable' do
    expect(command('certbot --version').exit_status).to eq 0
  end

  it 'should be scheduled' do
    expect(file('/reckerops/bin/certbot-renew.sh')).to exist
    expect(cron).to have_entry '0 1 * * sun /reckerops/bin/certbot-renew.sh'
  end
end
