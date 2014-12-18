require 'enc'
require 'json'
require 'open-uri'

# Returns roles by parsing JSON returned by hitting a url.
module Enc
  def self.url_provider(base)
    Proc.new do |hostname|
      JSON.parse open("#{base}/#{hostname}"){ |io| io.read }
    end
  end
end

