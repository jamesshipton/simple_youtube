This is an updated version of the active_youtube gem from the [Quark ruby blog](http://www.quarkruby.com/2008/2/12/active-youtube), I couldn't find the original to fork on github.

It works with the YouTube v2 API and provides an interface to Read YouTube data(no CUD access), with no API Key required.

`gem install simple_youtube`

I have tried to cover most of the examples from the [YouTube API reference](http://code.google.com/apis/youtube/2.0/reference.html)

## Video Search

###search for top 5 'ruby on rails' videos

[http://gdata.youtube.com/feeds/api/videos?q=ruby+on+rails&max-results=5&v=2](http://gdata.youtube.com/feeds/api/videos?q=ruby+on+rails&max-results=5&v=2)

    video_search = Youtube::Video.find(:params => {:q => 'ruby on rails', :"max-results" => '5', :v => '2'})
    video_search.entry.size             # => 5
    video_search.title                  # => "YouTube Videos matching query: ruby on rails"
    video_search.entry[3].link[1].href  # => http://gdata.youtube.com/feeds/api/videos/UCB57Npj9U0/responses?v=2
    
   
###search for related videos

[http://gdata.youtube.com/feeds/api/videos/rFVHjZYoq4Q/related?v=2](http://gdata.youtube.com/feeds/api/videos/rFVHjZYoq4Q/related?v=2)

    video_related = Youtube::Video.find(:scope => 'rFVHjZYoq4Q', :type => 'related', :params => {:v => '2'})
    video_related.entry.size            # => 25
    video_related.entry[24].author.uri  # => http://gdata.youtube.com/feeds/api/users/neodracco
    

###search for video responses

[http://gdata.youtube.com/feeds/api/videos/rFVHjZYoq4Q/responses?v=2](http://gdata.youtube.com/feeds/api/videos/rFVHjZYoq4Q/responses?v=2)

    video_responses = Youtube::Video.find(:scope => 'rFVHjZYoq4Q', :type => 'responses', :params => {:v => '2'})
    video_responses.entry[1].group.category  # => Music
    

###search for video comments

[http://gdata.youtube.com/feeds/api/videos/rFVHjZYoq4Q/comments?v=2](http://gdata.youtube.com/feeds/api/videos/rFVHjZYoq4Q/comments?v=2)

    video_comments = Youtube::Video.find(:scope => 'rFVHjZYoq4Q', :type => 'comments', :params => {:v => '2'})
    video_comments.entry[0].content         # => Come up to my first ever e on this about 14-15 years ago, ahh too long...
    

###search for top 11 videos in Comedy category/tag

[http://gdata.youtube.com/feeds/api/videos?category=Comedy&max-results=11&v=2](http://gdata.youtube.com/feeds/api/videos?category=Comedy&max-results=11&v=2)

    video_category = Youtube::Video.find(:params => {:category => 'Comedy', :"max-results" => '11', :v => '2'})
    video_category.entry.size  # => 11
    video_category.entry[9].category[2].term  # => Harry Potter
    video_category.entry[0].category[1].term  # => Comedy
    

###search for top 5 videos in Comedy category/tag, excluding Film category/tag

[http://gdata.youtube.com/feeds/api/videos?category=Comedy%2C-Film&max-results=5&v=2](http://gdata.youtube.com/feeds/api/videos?category=Comedy%2C-Film&max-results=5&v=2)

    video_category_comedy_exclude_film = Youtube::Video.find(:params => {:category => 'Comedy,-Film', :"max-results" => '5', :v => '2'})
    video_category_comedy_exclude_film.entry[1].category.size  # => 18
    video_category_comedy_exclude_film.entry[1].category.each { |category| puts 'film' if category.term.eql?('Film') }  #=> nil
    

###search for videos in david, beckham,(News or Sports) category/tags

[http://gdata.youtube.com/feeds/api/videos?category=david%2Cbeckham%2CNews%7CSports&v=2](http://gdata.youtube.com/feeds/api/videos?category=david%2Cbeckham%2CNews%7CSports&v=2)

    video_category_david_beckham_news_or_sports = Youtube::Video.find(:params => {:category => 'david,beckham,News|Sports', :v => '2'})
    video_category_david_beckham_news_or_sports.entry[7].category[1].label  # => Sports
    video_category_david_beckham_news_or_sports.entry[7].category[2].term   # => david
    
    
## StandardFeed Search
    
### search for top rated videos from today

[http://gdata.youtube.com/feeds/api/standardfeeds/top_rated?time=today&v=2](http://gdata.youtube.com/feeds/api/standardfeeds/top_rated?time=today&v=2)
    standardfeed_topratedtoday = Youtube::Standardfeed.find(:type => 'top_rated', :params => {:time => 'today', :v => '2'})
    standardfeed_topratedtoday.entry[16].author.name = "ZOMGitsCriss"
  
### search for top rated videos from jp

[http://gdata.youtube.com/feeds/api/standardfeeds/JP/top_rated?v=2](http://gdata.youtube.com/feeds/api/standardfeeds/JP/top_rated?v=2)
    standardfeed_toprated_jp = Youtube::Standardfeed.find(:scope => 'JP', :type => 'top_rated', :params => {:v => '2'})
    standardfeed_toprated_jp.id = "tag:youtube.com,2008:standardfeed:jp:top_rated"
    standardfeed_toprated_jp.entry[1].link[4].href = "http://gdata.youtube.com/feeds/api/standardfeeds/jp/top_rated/v/BQ9YtJC-Kd8?v=2"
  
  
### search for top rated comedy videos from jp
    
[http://gdata.youtube.com/feeds/api/standardfeeds/JP/top_rated?category=Comedy&max-results=11&v=2]("http://gdata.youtube.com/feeds/api/standardfeeds/jp/top_rated/v/7hYGkqc1gqE?v=2")
    standardfeed_toprated_jp_comedy = Youtube::Standardfeed.find(:scope => 'JP', :type => 'top_rated', :params => {:category => 'Comedy', :"max-results" => '11', :v => '2'})
    standardfeed_toprated_jp_comedy.entry[1].link[4].href = "http://gdata.youtube.com/feeds/api/standardfeeds/jp/top_rated/v/7hYGkqc1gqE?v=2"


Big Thanks to the Quark crew for the inspiration!!!



