require 'spec_helper'

describe 'YoutubeUpdateSpec' do
  it 'updates a video on youtube' do

    access_token = double('access_token')
    oauth_token = 'oauth_token'
    x_gdata_key = 'x_gdata_key'
    video_uid = 'video_uid'
    user_name = 'user_name'
    update_xml = IO.read(SimpleYoutube::ROOT + '/spec/fixture/video_update.xml')

    RestClient.should_receive(:put).with(
        "http://gdata.youtube.com/feeds/api/users/#{user_name}/uploads/#{video_uid}",
        update_xml,
        { 'Authorization' => "Bearer #{oauth_token}",
          'Content-Type'  => 'application/atom+xml',
          'GData-Version' => '2',
          'X-GData-Key'   => "key=#{x_gdata_key}" }).
      and_return(Net::HTTPResponse.new(1.1, 200, 'OK'))

    response = Youtube::Video.update(
      video_uid,
      user_name,
      update_xml,
      oauth_token,
      x_gdata_key)

    response.code.should == 200
  end
end
