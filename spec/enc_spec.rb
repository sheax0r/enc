require 'enc'
require 'enc/url_provider'
require 'webmock/rspec'

module Enc
  Enc.template_dir = File.join(File.dirname(__FILE__))

  describe self do
    it 'should generate a manifest with roles from a url' do
      Enc.role_provider = Enc.url_provider 'http://somewhere.com/roles'
      stub_request(:get, "http://somewhere.com/roles/host").to_return(:body => %w'role'.to_json)
      expect(Enc.manifest('host')).to eq( {
        'parameters' => { 'P1' => 'value1', 'P2' => 'value2' },
        'classes' => { 'C1' => {}, 'C2' => { 'key1' => 'value1' }, 'C3' => {} }
      })
    end

    it 'should generate a manifest with roles' do
      Enc.role_provider = Proc.new{ |h| %w'role' }
      expect(Enc.manifest('host')).to eq( {
        'parameters' => { 'P1' => 'value1', 'P2' => 'value2' },
        'classes' => { 'C1' => {}, 'C2' => { 'key1' => 'value1' }, 'C3' => {} }
      })
    end

    it 'should generate a manifest without roles' do
      Enc.role_provider = nil
      expect(Enc.manifest('host')).to eq( {
        'parameters' => { 'P2' => 'value2' },
        'classes' => { 'C2' => { 'key1' => 'value1' }, 'C3' => {} }
      })
    end

  end
end
