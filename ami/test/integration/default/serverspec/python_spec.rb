require 'serverspec'

set :backend, :exec

describe 'python' do
  it 'should be executable' do
    expect(command('python --version').exit_status).to eq 0
  end
end

describe 'pip' do
  it 'should be executable' do
    expect(command('pip --version').exit_status).to eq 0
  end
end
