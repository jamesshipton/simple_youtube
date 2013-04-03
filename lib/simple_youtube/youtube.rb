require 'simple_youtube/active_youtube'
#### Create classes for YouTube resources.
module Youtube
  class Video < ActiveYoutube
    def self.update scope, user_name, update_xml, oauth_token, x_gdata_key
      RestClient.put(
        "http://gdata.youtube.com/feeds/api/users/#{user_name}/uploads/#{scope}",
        update_xml,
        { 'Authorization' => "Bearer #{oauth_token}",
          'Content-Type'  => 'application/atom+xml',
          'GData-Version' => '2',
          'X-GData-Key'   => "key=#{x_gdata_key}" })
    end
  end

  class User < ActiveYoutube
  end

  class Standardfeed < ActiveYoutube
  end

  class Playlist < ActiveYoutube
  end
end
