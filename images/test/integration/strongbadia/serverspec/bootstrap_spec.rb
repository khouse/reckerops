require 'serverspec'

set :backend, :exec

describe 'bootstrap' do
  it 'should exist' do
    expect(file('/reckerops/bootstrap.sh')).to exist
  end
end
