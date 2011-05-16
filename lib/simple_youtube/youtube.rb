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
  end

  class User < ActiveYoutube
    include EntryInterfaceShim
  end

  class Standardfeed < ActiveYoutube
  end

  class Playlist < ActiveYoutube
  end
end
