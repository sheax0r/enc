require 'enc'

# Set env vars based on files in the /etc/enc directory.
module Enc
  def self.env!
    Dir.glob("/etc/enc/env/*").each do |file|
      ENV[File.basename(file)] = File.read(file)
    end
  end
end
