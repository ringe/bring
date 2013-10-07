$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir =
    File.expand_path('../fixtures/vcr_cassettes', __FILE__)

  config.hook_into :faraday
  config.configure_rspec_metadata!
end

RSpec.configure do |config|
  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  # This will be default behaviour in RSpec 3
  config.treat_symbols_as_metadata_keys_with_true_values = true

  config.extend VCR::RSpec::Macros

  def capture(stream)
    begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
    ensure
      eval("$#{stream} = #{stream.upcase}")
    end

    result
  end
end
