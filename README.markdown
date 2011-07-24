simple_youtube works with the YouTube v2 API to...

1) Read(:get) YouTube data with no API Key

2) Update(:put) YouTube video data using your Gdata API Key and OAuth. Pass in your OAuth token/secret. Watch Ryan B's great [Simple OmniAuth screencast](http://railscasts.com/episodes/241-simple-omniauth) for OAuth set up in Rails. Beforehand you'll also need to [authenticate and authorize your host to use the Google APIs](http://code.google.com/apis/accounts/docs/RegistrationForWebAppsAuto.html) to get a developer(x_gdata_key) key and host(host_secret) key

3) Currently no Create or Delete functionality.

I have tried to cover most of the examples from the [YouTube API reference](http://code.google.com/apis/youtube/2.0/reference.html)

## &nbsp;

`gem install simple_youtube`

## Video

### :get a single video uid

[http://gdata.youtube.com/feeds/api/videos/wOzOc0xxJu8?v=2](http://gdata.youtube.com/feeds/api/videos/wOzOc0xxJu8?v=2)

    video_uid = Youtube::Video.find(:scope => 'wOzOc0xxJu8', :params => {:v => '2'})
    video_uid.entry.size # => 1
    video_uid.entry[0].title # => "Michael Watford - So Into You (Dub Mix)"

### :get top 5 'ruby on rails' videos

[http://gdata.youtube.com/feeds/api/videos?q=ruby+on+rails&max-results=5&v=2](http://gdata.youtube.com/feeds/api/videos?q=ruby+on+rails&max-results=5&v=2)

    video_search = Youtube::Video.find(:params => {:q => 'ruby on rails', :"max-results" => '5', :v => '2'})
    video_search.entry.size             # => 5
    video_search.title                  # => "YouTube Videos matching query: ruby on rails"
    video_search.entry[3].link[1].href  # => http://gdata.youtube.com/feeds/api/videos/UCB57Npj9U0/responses?v=2
    
   
### :get related videos

[http://gdata.youtube.com/feeds/api/videos/rFVHjZYoq4Q/related?v=2](http://gdata.youtube.com/feeds/api/videos/rFVHjZYoq4Q/related?v=2)

    video_related = Youtube::Video.find(:scope => 'rFVHjZYoq4Q', :type => 'related', :params => {:v => '2'})
    video_related.entry.size            # => 25
    video_related.entry[24].author.uri  # => http://gdata.youtube.com/feeds/api/users/neodracco
    

### :get video responses

[http://gdata.youtube.com/feeds/api/videos/rFVHjZYoq4Q/responses?v=2](http://gdata.youtube.com/feeds/api/videos/rFVHjZYoq4Q/responses?v=2)

    video_responses = Youtube::Video.find(:scope => 'rFVHjZYoq4Q', :type => 'responses', :params => {:v => '2'})
    video_responses.entry[1].group.category  # => Music
    

### :get video comments

[http://gdata.youtube.com/feeds/api/videos/rFVHjZYoq4Q/comments?v=2](http://gdata.youtube.com/feeds/api/videos/rFVHjZYoq4Q/comments?v=2)

    video_comments = Youtube::Video.find(:scope => 'rFVHjZYoq4Q', :type => 'comments', :params => {:v => '2'})
    video_comments.entry[0].content         # => Come up to my first ever e on this about 14-15 years ago, ahh too long...
    

### :get top 11 videos in Comedy category/tag

[http://gdata.youtube.com/feeds/api/videos?category=Comedy&max-results=11&v=2](http://gdata.youtube.com/feeds/api/videos?category=Comedy&max-results=11&v=2)

    video_category = Youtube::Video.find(:params => {:category => 'Comedy', :"max-results" => '11', :v => '2'})
    video_category.entry.size  # => 11
    video_category.entry[9].category[2].term  # => Harry Potter
    video_category.entry[0].category[1].term  # => Comedy
    

### :get top 5 videos in Comedy category/tag, excluding Film category/tag

[http://gdata.youtube.com/feeds/api/videos?category=Comedy%2C-Film&max-results=5&v=2](http://gdata.youtube.com/feeds/api/videos?category=Comedy%2C-Film&max-results=5&v=2)

    video_category_comedy_exclude_film = Youtube::Video.find(:params => {:category => 'Comedy,-Film', :"max-results" => '5', :v => '2'})
    video_category_comedy_exclude_film.entry[1].category.size  # => 18
    video_category_comedy_exclude_film.entry[1].category.each { |category| puts 'film' if category.term.eql?('Film') }  #=> nil
    

### :get videos in david, beckham,(News or Sports) category/tags

[http://gdata.youtube.com/feeds/api/videos?category=david%2Cbeckham%2CNews%7CSports&v=2](http://gdata.youtube.com/feeds/api/videos?category=david%2Cbeckham%2CNews%7CSports&v=2)

    video_category_david_beckham_news_or_sports = Youtube::Video.find(:params => {:category => 'david,beckham,News|Sports', :v => '2'})
    video_category_david_beckham_news_or_sports.entry[7].category[1].label  # => Sports
    video_category_david_beckham_news_or_sports.entry[7].category[2].term   # => david
    
### :put an updated video

    video_uid = "video_uid"
    user_name = "user_name"
    update_xml = IO.read('fixture/video_update.xml')
    oauth_token = "oauth_token"
    oauth_token_secret = "oauth_token_secret"
    x_gdata_key = "x_gdata_key"
    host = "www.host.com"
    host_secret = "host_secret"
    
    response = Youtube::Video.update(video_uid, user_name, update_xml, oauth_token, oauth_token_secret, x_gdata_key, host, host_secret)
    response.code # => 200    
    
## Standardfeed
    
### :get top rated videos from today

[http://gdata.youtube.com/feeds/api/standardfeeds/top_rated?time=today&v=2](http://gdata.youtube.com/feeds/api/standardfeeds/top_rated?time=today&v=2)

    standardfeed_topratedtoday = Youtube::Standardfeed.find(:type => 'top_rated', :params => {:time => 'today', :v => '2'})
    standardfeed_topratedtoday.entry[16].author.name = "ZOMGitsCriss"
  
### :get top rated videos from jp

[http://gdata.youtube.com/feeds/api/standardfeeds/JP/top_rated?v=2](http://gdata.youtube.com/feeds/api/standardfeeds/JP/top_rated?v=2)

    standardfeed_toprated_jp = Youtube::Standardfeed.find(:scope => 'JP', :type => 'top_rated', :params => {:v => '2'})
    standardfeed_toprated_jp.id = "tag:youtube.com,2008:standardfeed:jp:top_rated"
    standardfeed_toprated_jp.entry[1].link[4].href = "http://gdata.youtube.com/feeds/api/standardfeeds/jp/top_rated/v/BQ9YtJC-Kd8?v=2"
  
  
### :get top rated comedy videos from jp
    
[http://gdata.youtube.com/feeds/api/standardfeeds/JP/top_rated?category=Comedy&max-results=11&v=2]("http://gdata.youtube.com/feeds/api/standardfeeds/jp/top_rated/v/7hYGkqc1gqE?v=2")

    standardfeed_toprated_jp_comedy = Youtube::Standardfeed.find(:scope => 'JP', :type => 'top_rated', :params => {:category => 'Comedy', :"max-results" => '11', :v => '2'})
    standardfeed_toprated_jp_comedy.entry[1].link[4].href = "http://gdata.youtube.com/feeds/api/standardfeeds/jp/top_rated/v/7hYGkqc1gqE?v=2"


## User 

### :get a single user

[http://gdata.youtube.com/feeds/api/users/neodracco](http://gdata.youtube.com/feeds/api/users/neodracco)
    
    user_search = Youtube::User.find(:scope => 'neodracco')
    user_search.entry.size => 1

### :get ionysis favourite videos
    
[http://gdata.youtube.com/feeds/api/users/ionysis/favorites?v=2](http://gdata.youtube.com/feeds/api/users/ionysis/favorites?v=2)

    user_ionysis_favourites = Youtube::User.find(:scope => 'ionysis', :type => 'favorites', :params => {:v => '2'})
    user_ionysis_favourites.entry[7].statistics.favoriteCount) = "9586"
    user_ionysis_favourites.entry[7].rating[1].numLikes) = "2568"
  
### :get cyanure1982 playlists

[http://gdata.youtube.com/feeds/api/users/cyanure1982/playlists?v=2](http://gdata.youtube.com/feeds/api/users/cyanure1982/playlists?v=2)

    user_cyanure1982_playlists = Youtube::User.find(:scope => 'cyanure1982', :type => 'playlists', :params => {:v => '2'})
    user_cyanure1982_playlists.entry[2].title) = "shinnenkai"
  
### :get ionysis subscriptions

[http://gdata.youtube.com/feeds/api/users/ionysis/subscriptions?v=2](http://gdata.youtube.com/feeds/api/users/ionysis/subscriptions?v=2)

    user_ionysis_subscriptions = Youtube::User.find(:scope => 'ionysis', :type => 'subscriptions', :params => {:v => '2'})
    user_ionysis_subscriptions.entry[0].title) = "Videos published by : vinyljunkie07"
  
### :get vinyljunkie07 contacts

[http://gdata.youtube.com/feeds/api/users/vinyljunkie07/contacts?v=2](http://gdata.youtube.com/feeds/api/users/vinyljunkie07/contacts?v=2)

    user_vinyljunkie07_contacts = Youtube::User.find(:scope => 'vinyljunkie07', :type => 'contacts', :params => {:v => '2'})
    user_vinyljunkie07_contacts.entry[18].id) "tag:youtube.com,2008:user:vinyljunkie07:contact:CrackerSchool"
    

## Playlist 
   
### :get the cyanure1982 playlist - shinnenkai(D00BDE6AA710D50C)

[http://gdata.youtube.com/feeds/api/playlists/D00BDE6AA710D50C?max-results=14&v=2](http://gdata.youtube.com/feeds/api/playlists/D00BDE6AA710D50C?max-results=14&v=2)

    playlist_cyanure1982 = Youtube::Playlist.find(:scope => 'D00BDE6AA710D50C', :params => {:"max-results" => '14', :v => '2'})
    playlist_cyanure1982.entry.size = 14
    playlist_cyanure1982.entry[7].group.keywords = "nu, jazz, club, house, Jazztronik, dj, Yukihiro, Fukutomi, Mondo, Grosso, Daishi, Dance, FreeTEMPO, FPM, KJM, Kentaro, Takizawa"
    
simple_youtube is derived from the active_youtube gem from the [Quark ruby blog](http://www.quarkruby.com/2008/2/12/active-youtube)
    
Big Thanks to the Quark crew for the inspiration!!!



