This is an updated version of the active_youtube gem from the [Quark ruby blog](http://www.quarkruby.com/2008/2/12/active-youtube), I couldn't find the original to fork on github.

It works with the YouTube v2 API and provides an interface to Read YouTube data(no CUD access), with no API Key required.

`sudo gem install simple_youtube`

I have tried to cover most of the examples from the [YouTube API reference](http://code.google.com/apis/youtube/2.0/reference.html)

## Examples

### Video Search

search for top 5 'ruby on rails' videos
[http://gdata.youtube.com/feeds/api/videos?q=ruby+on+rails&max-results=5&v=2]

    video_search = Youtube::Video.find(:params => {:q => 'ruby on rails', :"max-results" => '5', :v => '2'})
    video_search.entry.size             # => 5
    video_search.title                  # => "YouTube Videos matching query: ruby on rails"
    video_search.entry[3].link[1].href  # => http://gdata.youtube.com/feeds/api/videos/UCB57Npj9U0/responses?v=2




Big Thanks to the Quark crew for the inspiration!!!



