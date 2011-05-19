require 'fakeweb'

module FakewebHelper 
  # Make sure nothing gets out (IMPORTANT)  
  FakeWeb.allow_net_connect = false  

  # Turns a fixture file name into a full path  
  def fixture_file(filename)  
    return '' if filename == ''  
    File.expand_path('./fixture/' + filename)  
  end  

  # Convenience methods for stubbing URLs to fixtures  
  def stub_get(url, filename)  
    FakeWeb.register_uri(:get, url, :response => fixture_file(filename))  
  end  

end