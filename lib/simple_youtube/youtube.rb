require 'oauth'

#### Create classes for YouTube resources.
module Youtube

  class Video < ActiveYoutube

    def self.update scope, user_name, update_xml, oauth_token, oauth_token_secret, x_gdata_key, host, host_secret
      consumer = OAuth::Consumer.new(host, host_secret, {:site=>"https://www.google.com", :request_token_path=>"/accounts/OAuthGetRequestToken", :authorize_path=>"/accounts/OAuthAuthorizeToken", :access_token_path=>"/accounts/OAuthGetAccessToken"})
      access_token = OAuth::AccessToken.new(consumer, oauth_token, oauth_token_secret)
      access_token.put("http://gdata.youtube.com/feeds/api/users/#{user_name}/uploads/#{scope}", update_xml, {'Accept' => 'application/atom+xml', 'Content-Type' => 'application/atom+xml', 'X-GData-Key' => "key=#{x_gdata_key}" })
    end

  end

  class User < ActiveYoutube
  end

  class Standardfeed < ActiveYoutube
  end

  class Playlist < ActiveYoutube
  end

end
