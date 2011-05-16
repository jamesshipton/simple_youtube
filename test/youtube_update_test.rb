require "test/unit"
require File.dirname(__FILE__) + "/../lib/" + "simple_youtube"
require File.dirname(__FILE__) + "/fakeweb_helper"

class YoutubeUpdateTest < Test::Unit::TestCase

  include FakewebHelper
  
  def test_video_update
    #video_update = Youtube::Video.update(:scope => 'wOzOc0xxJu8', :type => 'uploads')
  end

end