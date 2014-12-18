require 'enc/env'

describe Enc do
  it 'should set env vars' do
    expect(Dir).to receive(:glob).with('/etc/enc/env/*'){ %w'/etc/enc/key' } 
    expect(File).to receive(:read).with('/etc/enc/key'){ 'value' }
    expect(ENV).to receive(:[]=).with('key', 'value')
    Enc.env!
  end
end
