#### Create classes for YouTube resources.
module Youtube

  #
  # This module provides the interface for a response object to have
  # a #entry method regardless of the response object being a single
  # entry or a collection of entries
  #
  module EntryInterfaceShim
    def entry
      if attributes.has_key?('entry')
        return attributes['entry']
      else
        [self]
      end
    end
  end

  class Video < ActiveYoutube
    include EntryInterfaceShim

    def method_missing(method_symbol, *args)
      method_name = method_symbol.to_s
      return attributes[method_name] if attributes.include?(method_name)
      return nil if known_attributes.include?(method_name)
      super
    end
  end

  class User < ActiveYoutube
    include EntryInterfaceShim
  end

  class Standardfeed < ActiveYoutube
  end

  class Playlist < ActiveYoutube
  end
end
