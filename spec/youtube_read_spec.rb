require 'spec_helper'

describe 'YoutubeFindSpec' do

  include FakewebHelper

  it "finds video search for uid", :wip do
    stub_get('http://gdata.youtube.com/feeds/api/videos/wOzOc0xxJu8?v=2', 'video_uid.xml')
    video_uid = Youtube::Video.find(:scope => 'wOzOc0xxJu8', :params => {:v => '2'})
    video_uid.entry.size.should == 1
    video_uid.entry[0].title.should == "Michael Watford - So Into You (Dub Mix)"
  end
  
  it "fails to connect to Youtube", :fail do    
    stub_http_error(:get, 'http://gdata.youtube.com/feeds/api/videos/wOzOc0xxJu8?v=2', '500', 'Server Error')
    lambda {Youtube::Video.find(:scope => 'wOzOc0xxJu8', :params => {:v => '2'})}.should raise_error(ActiveResource::ServerError, "Failed.  Response code = 500.  Response message = Server Error.")
  end

  it "finds video search for top 5 ruby on rails videos" do
    stub_get('http://gdata.youtube.com/feeds/api/videos?q=ruby+on+rails&max-results=5&v=2', 'video_search.xml')
    video_search = Youtube::Video.find(:params => {:q => 'ruby on rails', :"max-results" => '5', :v => '2'})
    video_search.entry.size.should == 5 
    video_search.title.should == "YouTube Videos matching query: ruby on rails"
    video_search.entry[3].link[1].href.should == "http://gdata.youtube.com/feeds/api/videos/UCB57Npj9U0/responses?v=2"
  end

  it "finds video search for related videos" do
    stub_get('http://gdata.youtube.com/feeds/api/videos/rFVHjZYoq4Q/related?v=2', 'video_related.xml')
    video_related = Youtube::Video.find(:scope => 'rFVHjZYoq4Q', :type => 'related', :params => {:v => '2'})
    video_related.entry.size.should == 25
    video_related.entry[24].author.uri.should == "http://gdata.youtube.com/feeds/api/users/neodracco"
  end

  it "finds video search for video responses" do
    stub_get('http://gdata.youtube.com/feeds/api/videos/rFVHjZYoq4Q/responses?v=2', 'video_responses.xml')
    video_responses = Youtube::Video.find(:scope => 'rFVHjZYoq4Q', :type => 'responses', :params => {:v => '2'})
    video_responses.entry[1].group.category.should == "Music"
  end

  it "finds video search for video comments" do
    stub_get('http://gdata.youtube.com/feeds/api/videos/rFVHjZYoq4Q/comments?v=2', 'video_comments.xml')
    video_comments = Youtube::Video.find(:scope => 'rFVHjZYoq4Q', :type => 'comments', :params => {:v => '2'})
    video_comments.entry[0].content.should == "Come up to my first ever e on this about 14-15 years ago, ahh too long..."
  end

  it "finds video search for top 11 videos in Comedy category" do
    stub_get('http://gdata.youtube.com/feeds/api/videos?category=Comedy&max-results=11&v=2', 'video_category_comedy.xml')
    video_category = Youtube::Video.find(:params => {:category => 'Comedy', :"max-results" => '11', :v => '2'})
    video_category.entry.size.should == 11
    video_category.entry[9].category[2].term.should == "Harry Potter"
    video_category.entry[0].category[1].term.should == "Comedy"
  end

  it "finds video search for top 5 videos in Comedy category excluding Film category" do
    stub_get('http://gdata.youtube.com/feeds/api/videos?category=Comedy%2C-Film&max-results=5&v=2', 'video_category_comedy_exclude_film.xml')
    video_category_comedy_exclude_film = Youtube::Video.find(:params => {:category => 'Comedy,-Film', :"max-results" => '5', :v => '2'})
    video_category_comedy_exclude_film.entry[1].category.size.should == 18
    video_category_comedy_exclude_film.entry[1].category.each { |category|
      category.term.should_not == "Film"
    }
  end

  it "finds video search for videos in david beckham News or Sports category" do
    stub_get('http://gdata.youtube.com/feeds/api/videos?category=david%2Cbeckham%2CNews%7CSports&v=2', 'video_category_david_beckham_news_or_sports.xml')
    video_category_david_beckham_news_or_sports = Youtube::Video.find(:params => {:category => 'david,beckham,News|Sports', :v => '2'})
    video_category_david_beckham_news_or_sports.entry[7].category[1].label.should == "Sports"
    video_category_david_beckham_news_or_sports.entry[7].category[2].term.should == "david" 
    video_category_david_beckham_news_or_sports.entry[7].category[3].term.should == "beckham" 
    video_category_david_beckham_news_or_sports.entry[8].category[1].term.should == "News"
    video_category_david_beckham_news_or_sports.entry[8].category[9].term.should == "David Beckham"
  end

  it "finds standardfeed search for top rated videos from today" do
    stub_get('http://gdata.youtube.com/feeds/api/standardfeeds/top_rated?time=today&v=2', 'standardfeed_toprated_today.xml')
    standardfeed_topratedtoday = Youtube::Standardfeed.find(:type => 'top_rated', :params => {:time => 'today', :v => '2'})
    standardfeed_topratedtoday.entry[16].author.name.should == "ZOMGitsCriss"
  end

  it "finds standardfeed search for top rated videos from jp" do
    stub_get('http://gdata.youtube.com/feeds/api/standardfeeds/JP/top_rated?v=2', 'standardfeed_toprated_jp.xml')
    standardfeed_toprated_jp = Youtube::Standardfeed.find(:scope => 'JP', :type => 'top_rated', :params => {:v => '2'})
    standardfeed_toprated_jp.id.should == "tag:youtube.com,2008:standardfeed:jp:top_rated"
    standardfeed_toprated_jp.entry[1].link[4].href.should == "http://gdata.youtube.com/feeds/api/standardfeeds/jp/top_rated/v/BQ9YtJC-Kd8?v=2"
  end

  it "finds standardfeed search for top rated comedy videos from jp" do
    stub_get('http://gdata.youtube.com/feeds/api/standardfeeds/JP/top_rated?category=Comedy&max-results=11&v=2', 'standardfeed_toprated_jp_comedy.xml')
    standardfeed_toprated_jp_comedy = Youtube::Standardfeed.find(:scope => 'JP', :type => 'top_rated', :params => {:category => 'Comedy', :"max-results" => '11', :v => '2'})
    standardfeed_toprated_jp_comedy.entry[1].link[4].href.should == "http://gdata.youtube.com/feeds/api/standardfeeds/jp/top_rated/v/7hYGkqc1gqE?v=2"
  end

  it "finds user feed for single user" do
    stub_get("http://gdata.youtube.com/feeds/api/users/neodracco", 'user_neodracco.xml')
    user_search = Youtube::User.find(:scope => 'neodracco')
    user_search.entry.size.should == 1
  end

  it "finds user search for ionysis favourite videos" do
    stub_get('http://gdata.youtube.com/feeds/api/users/ionysis/favorites?v=2', 'user_ionysis_favourites.xml')
    user_ionysis_favourites = Youtube::User.find(:scope => 'ionysis', :type => 'favorites', :params => {:v => '2'})
    user_ionysis_favourites.entry[7].statistics.favoriteCount.should == "9586"
    user_ionysis_favourites.entry[7].rating[1].numLikes.should == "2568"
  end

  it "finds user search for cyanure1982 playlists" do
    stub_get('http://gdata.youtube.com/feeds/api/users/cyanure1982/playlists?v=2', 'user_cyanure1982_playlists.xml')
    user_cyanure1982_playlists = Youtube::User.find(:scope => 'cyanure1982', :type => 'playlists', :params => {:v => '2'})
    user_cyanure1982_playlists.entry[2].title.should == "shinnenkai"
  end

  it "finds user search for ionysis subscriptions" do
    stub_get('http://gdata.youtube.com/feeds/api/users/ionysis/subscriptions?v=2', 'user_ionysis_subscriptions.xml')
    user_ionysis_subscriptions = Youtube::User.find(:scope => 'ionysis', :type => 'subscriptions', :params => {:v => '2'})
    user_ionysis_subscriptions.entry[0].title.should == "Videos published by : vinyljunkie07"
  end

  it "finds user search for vinyljunkie07 contacts" do
    stub_get('http://gdata.youtube.com/feeds/api/users/vinyljunkie07/contacts?v=2', 'user_vinyljunkie07_contacts.xml')
    user_vinyljunkie07_contacts = Youtube::User.find(:scope => 'vinyljunkie07', :type => 'contacts', :params => {:v => '2'})
    user_vinyljunkie07_contacts.entry[18].id.should == "tag:youtube.com,2008:user:vinyljunkie07:contact:CrackerSchool"
  end

  it "finds playlist search for the cyanure1982 playlist shinnenkai D00BDE6AA710D50C" do
    stub_get('http://gdata.youtube.com/feeds/api/playlists/D00BDE6AA710D50C?max-results=14&v=2', 'playlist_cyanure1982.xml')
    playlist_cyanure1982 = Youtube::Playlist.find(:scope => 'D00BDE6AA710D50C', :params => {:"max-results" => '14', :v => '2'})
    playlist_cyanure1982.entry.size.should == 14
    playlist_cyanure1982.entry[7].group.keywords.should == "nu, jazz, club, house, Jazztronik, dj, Yukihiro, Fukutomi, Mondo, Grosso, Daishi, Dance, FreeTEMPO, FPM, KJM, Kentaro, Takizawa"
  end

end