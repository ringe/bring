require 'spec_helper'
require 'bring/configurator'

describe Bring::Configurator do
  let(:configurator) { Bring::Configurator.instance }

  describe 'self.configuration' do
    it 'returns self' do
      expect(Bring.config).to be configurator
    end

    it 'takes a block' do
      expect(configurator).to receive(:foo).and_return('bar')

      Bring.config do |config|
        expect(config.foo).to eq 'bar'
      end
    end
  end
end
