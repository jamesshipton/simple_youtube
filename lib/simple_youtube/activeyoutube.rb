require 'rubygems'
require 'active_resource'

class ActiveYoutube < ActiveResource::Base

  self.site = "http://gdata.youtube.com/feeds/api"

  def self.find(args)
    scope, type, query = args[:scope], args[:type], args[:params]
    headers['Accept'] = "application/atom+xml"
    path = "#{prefix()}#{collection_name}#{'/' if scope}#{scope}#{'/' if type}#{type}#{query_string(query)}"
    convert_entry_to_array(instantiate_record(connection.get(path, headers))) 
  end     

  #if youtube only returns a single entry, then convert to an array to standardize subsequent feed processing
  def self.convert_entry_to_array object
    if object.respond_to?:entry and !(object.entry.kind_of? Array)
      object.entry=[object.entry]
    end
    object
  end

end
