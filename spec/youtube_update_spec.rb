require 'spec_helper'

describe 'YoutubeUpdateSpec' do
  it 'updates a video on youtube' do
    consumer = double('consumer')
    access_token = double('access_token')
    host = 'www.host.com'
    host_secret = 'host_secret'
    oauth_token = 'oauth_token'
    oauth_token_secret = "oauth_token_secret"
    x_gdata_key = 'x_gdata_key'
    video_uid = 'video_uid'
    user_name = 'user_name'
    update_xml = IO.read('fixture/video_update.xml')

    OAuth::Consumer.should_receive(:new).
      with(
        host,
        host_secret,
        { :site => 'https://www.google.com',
          :request_token_path => '/accounts/OAuthGetRequestToken',
          :authorize_path => '/accounts/OAuthAuthorizeToken',
          :access_token_path => '/accounts/OAuthGetAccessToken' }).
      and_return(consumer)

    OAuth::AccessToken.should_receive(:new).
      with(consumer, oauth_token, oauth_token_secret).
      and_return(access_token)

    access_token.should_receive(:put).
      with(
        "http://gdata.youtube.com/feeds/api/users/#{user_name}/uploads/#{video_uid}",
        update_xml,
        { 'Accept' => 'application/atom+xml',
          'Content-Type' => 'application/atom+xml',
          'X-GData-Key' => x_gdata_key}).
      and_return(Net::HTTPResponse.new(1.0, 200, 'OK'))

    response = Youtube::Video.update(
      video_uid,
      user_name,
      update_xml,
      oauth_token,
      oauth_token_secret,
      x_gdata_key, host,
      host_secret)

    response.code.should == 200
  end
end
