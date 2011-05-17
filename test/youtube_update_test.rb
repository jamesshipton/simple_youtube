require "test/unit"
require File.dirname(__FILE__) + "/../lib/" + "simple_youtube"
require File.dirname(__FILE__) + "/fakeweb_helper"

class YoutubeUpdateTest < Test::Unit::TestCase

  include FakewebHelper
  
  def test_video_update
    #video_update = Youtube::Video.update(:scope => 'wOzOc0xxJu8', :oauth_token => "oauth_token", :oauth_token_secret => "oauth_token_secret", :x_gdata_key => "x_gdata_key", :host => "www.host.com", :host_secret => "host_secret")
  end

end