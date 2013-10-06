require 'spec_helper'
require 'bring/cli'

describe Bring::CLI, :vcr do
  def invoke!(*args)
    capture(:stdout) { Bring::CLI.start(args) }
  end

  describe 'postal_code' do
    it 'displays city for pnr' do
      expect(invoke! 'postal_code', '0190').to eq "OSLO\n"
    end

    it 'takes a country' do
      arguments = %w[postal_code 12000 --country se]
      expect(invoke!(*arguments)).to eq "Stockholm\n"
    end
  end
end
