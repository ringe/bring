require 'singleton'

module Bring
  def self.config(&block)
    config = Bring::Configurator.instance
    yield config if block_given?

    config
  end

  class Configurator
    include Singleton

    # Specify Faraday adapter or use `Faraday.default_adapter` by default.
    attr_accessor :faraday_adapter
  end
end
