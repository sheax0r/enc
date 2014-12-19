require 'yaml'

# http://stackoverflow.com/questions/9381553/ruby-merge-nested-hash
class ::Hash
  def deep_merge(second)
    merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
    self.merge(second, &merger)
  end
end

module Enc
  class << self
    attr_accessor :role_provider
    attr_accessor :template_dir

    template_dir = '/etc/enc/manifests'

    # Generate a manifest for the given host
    def manifest(hostname)
      roles = role_provider ? role_provider.call(hostname) : []
      Manifest.new(hostname, roles).hash
    end
  end

  class Manifest
    attr_reader :hostname, :roles

    def initialize(hostname, roles)
      @hostname, @roles = hostname, roles
    end  

    def hash 
      manifests.inject({}){ |result, m| result.deep_merge(m) }
    end

    def manifests 
      files.map{ |f| YAML.load(File.read(f)) }
    end

    def files
      roles.push(hostname).map{ |r| file(r) }.select{ |f| File.exists?(f)  }
    end

    def file(role)
      "#{Enc.template_dir}/#{role}.yml"
    end
  end

end
