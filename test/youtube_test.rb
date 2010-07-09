require "test/unit"
require File.dirname(__FILE__) + "/../lib/" + "simple_youtube"
require File.dirname(__FILE__) + "/fakeweb_helper"

class YoutubeTest < Test::Unit::TestCase
  
  include FakewebHelper

  def test_video
    ## search for top 5 'ruby on rails' videos
    stub_get('http://gdata.youtube.com/feeds/api/videos?q=ruby+on+rails&max-results=5&v=2', 'video_search.xml')
    video_search = Youtube::Video.find(:params => {:q => 'ruby on rails', :"max-results" => '5', :v => '2'})
    assert_equal(5, video_search.entry.size)
    assert_equal("YouTube Videos matching query: ruby on rails", video_search.title)
    assert_equal("http://gdata.youtube.com/feeds/api/videos/UCB57Npj9U0/responses?v=2", video_search.entry[3].link[1].href)

    ## search for related videos
    stub_get('http://gdata.youtube.com/feeds/api/videos/rFVHjZYoq4Q/related?v=2', 'video_related.xml')
    video_related = Youtube::Video.find(:scope => 'rFVHjZYoq4Q', :type => 'related', :params => {:v => '2'})
    assert_equal(25, video_related.entry.size)
    assert_equal("http://gdata.youtube.com/feeds/api/users/neodracco", video_related.entry[24].author.uri)
    
    ## search for video responses
    stub_get('http://gdata.youtube.com/feeds/api/videos/rFVHjZYoq4Q/responses?v=2', 'video_responses.xml')
    video_responses = Youtube::Video.find(:scope => 'rFVHjZYoq4Q', :type => 'responses', :params => {:v => '2'})
    assert_equal("Music", video_responses.entry[1].group.category)
    
    ## search for video comments
    stub_get('http://gdata.youtube.com/feeds/api/videos/rFVHjZYoq4Q/comments?v=2', 'video_comments.xml')
    video_comments = Youtube::Video.find(:scope => 'rFVHjZYoq4Q', :type => 'comments', :params => {:v => '2'})
    assert_equal("Come up to my first ever e on this about 14-15 years ago, ahh too long...", video_comments.entry[0].content)
    
    ## search for top 11 videos in Comedy category/tag
    stub_get('http://gdata.youtube.com/feeds/api/videos?category=Comedy&max-results=11&v=2', 'video_category_comedy.xml')
    video_category = Youtube::Video.find(:params => {:category => 'Comedy', :"max-results" => '11', :v => '2'})
    assert_equal(11, video_category.entry.size)
    assert_equal("Harry Potter", video_category.entry[9].category[2].term)
    assert_equal("Comedy", video_category.entry[0].category[1].term)
    
    ## search for top 5 videos in Comedy category/tag, excluding Film category/tag
    stub_get('http://gdata.youtube.com/feeds/api/videos?category=Comedy%2C-Film&max-results=5&v=2', 'video_category_comedy_exclude_film.xml')
    video_category_comedy_exclude_film = Youtube::Video.find(:params => {:category => 'Comedy,-Film', :"max-results" => '5', :v => '2'})
    assert_equal(18, video_category_comedy_exclude_film.entry[1].category.size)
    video_category_comedy_exclude_film.entry[1].category.each { |category|
      assert_not_equal("Film", category.term) 
    }
    
    ## search for videos in david, beckham,(News or Sports) category/tags
    stub_get('http://gdata.youtube.com/feeds/api/videos?category=david%2Cbeckham%2CNews%7CSports&v=2', 'video_category_david_beckham_news_or_sports.xml')
    video_category_david_beckham_news_or_sports = Youtube::Video.find(:params => {:category => 'david,beckham,News|Sports', :v => '2'})
    assert_equal("Sports", video_category_david_beckham_news_or_sports.entry[7].category[1].label)
    assert_equal("david", video_category_david_beckham_news_or_sports.entry[7].category[2].term)
    assert_equal("beckham", video_category_david_beckham_news_or_sports.entry[7].category[3].term) 
    assert_equal("News", video_category_david_beckham_news_or_sports.entry[8].category[1].term)
    assert_equal("David Beckham", video_category_david_beckham_news_or_sports.entry[8].category[9].term)
  end

  def test_standardfeed
    ## search for top rated videos from today
    stub_get('http://gdata.youtube.com/feeds/api/standardfeeds/top_rated?time=today&v=2', 'standardfeed_toprated_today.xml')
    standardfeed_topratedtoday = Youtube::Standardfeed.find(:type => 'top_rated', :params => {:time => 'today', :v => '2'})
    assert_equal("ZOMGitsCriss", standardfeed_topratedtoday.entry[16].author.name)
  
    ## search for top rated videos from jp
    stub_get('http://gdata.youtube.com/feeds/api/standardfeeds/JP/top_rated?v=2', 'standardfeed_toprated_jp.xml')
    standardfeed_toprated_jp = Youtube::Standardfeed.find(:scope => 'JP', :type => 'top_rated', :params => {:v => '2'})
    assert_equal("tag:youtube.com,2008:standardfeed:jp:top_rated", standardfeed_toprated_jp.id)
    assert_equal("http://gdata.youtube.com/feeds/api/standardfeeds/jp/top_rated/v/BQ9YtJC-Kd8?v=2", standardfeed_toprated_jp.entry[1].link[4].href)
  
    ## search for top rated comedy videos from jp
    stub_get('http://gdata.youtube.com/feeds/api/standardfeeds/JP/top_rated?category=Comedy&max-results=11&v=2', 'standardfeed_toprated_jp_comedy.xml')
    standardfeed_toprated_jp_comedy = Youtube::Standardfeed.find(:scope => 'JP', :type => 'top_rated', :params => {:category => 'Comedy', :"max-results" => '11', :v => '2'})
    assert_equal("http://gdata.youtube.com/feeds/api/standardfeeds/jp/top_rated/v/7hYGkqc1gqE?v=2", standardfeed_toprated_jp_comedy.entry[1].link[4].href)      
  end
  
  def test_user
    ## search for ionysis favourite videos
    stub_get('http://gdata.youtube.com/feeds/api/users/ionysis/favorites?v=2', 'user_ionysis_favourites.xml')
    user_ionysis_favourites = Youtube::User.find(:scope => 'ionysis', :type => 'favorites', :params => {:v => '2'})
    assert_equal("9586", user_ionysis_favourites.entry[7].statistics.favoriteCount)
    assert_equal("2568", user_ionysis_favourites.entry[7].rating[1].numLikes)
  
    ## search for cyanure1982 playlists
    stub_get('http://gdata.youtube.com/feeds/api/users/cyanure1982/playlists?v=2', 'user_cyanure1982_playlists.xml')
    user_cyanure1982_playlists = Youtube::User.find(:scope => 'cyanure1982', :type => 'playlists', :params => {:v => '2'})
    assert_equal("shinnenkai", user_cyanure1982_playlists.entry[2].title)    
  
    ## search for ionysis subscriptions
    stub_get('http://gdata.youtube.com/feeds/api/users/ionysis/subscriptions?v=2', 'user_ionysis_subscriptions.xml')
    user_ionysis_subscriptions = Youtube::User.find(:scope => 'ionysis', :type => 'subscriptions', :params => {:v => '2'})
    assert_equal("Videos published by : vinyljunkie07", user_ionysis_subscriptions.entry[0].title)
  
    ## search for vinyljunkie07 contacts
    stub_get('http://gdata.youtube.com/feeds/api/users/vinyljunkie07/contacts?v=2', 'user_vinyljunkie07_contacts.xml')
    user_vinyljunkie07_contacts = Youtube::User.find(:scope => 'vinyljunkie07', :type => 'contacts', :params => {:v => '2'})
    assert_equal("tag:youtube.com,2008:user:vinyljunkie07:contact:CrackerSchool", user_vinyljunkie07_contacts.entry[18].id)        
  end
  
  def test_playlist
    ## search for the cyanure1982 playlist - shinnenkai(D00BDE6AA710D50C)
    stub_get('http://gdata.youtube.com/feeds/api/playlists/D00BDE6AA710D50C?max-results=14&v=2', 'playlist_cyanure1982.xml')
    playlist_cyanure1982 = Youtube::Playlist.find(:scope => 'D00BDE6AA710D50C', :params => {:"max-results" => '14', :v => '2'})
    assert_equal(14, playlist_cyanure1982.entry.size)
    assert_equal("nu, jazz, club, house, Jazztronik, dj, Yukihiro, Fukutomi, Mondo, Grosso, Daishi, Dance, FreeTEMPO, FPM, KJM, Kentaro, Takizawa", 
    playlist_cyanure1982.entry[7].group.keywords)
  end

end