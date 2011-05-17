require 'rubygems'
require 'active_resource'
require File.dirname(__FILE__) + "/entry_interface_shim"

class ActiveYoutube < ActiveResource::Base
  
  include EntryInterfaceShim

  self.site = "http://gdata.youtube.com/feeds/api"

  def self.find(args)
    scope, type, query = args[:scope], args[:type], args[:params]
    headers['Accept'] = "application/atom+xml"
    path = "#{prefix()}#{collection_name}#{'/' if scope}#{scope}#{'/' if type}#{type}#{query_string(query)}"
    instantiate_record(connection.get(path, headers)) 
  end  
  
end
