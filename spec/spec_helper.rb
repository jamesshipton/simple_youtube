require File.dirname(__FILE__) + "/../lib/" + "simple_youtube"
require File.dirname(__FILE__) + "/fakeweb_helper"

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
  c.color_enabled = true  
end
