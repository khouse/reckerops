require 'serverspec'

set :backend, :exec

describe 'python' do
  it 'should be installed' do
    expect(package('python')).to be_installed
  end

  it 'should be executable' do
    expect(command('python --version').exit_status).to eq 0
    expect(command('pip --version').exit_status).to eq 0
  end
end
