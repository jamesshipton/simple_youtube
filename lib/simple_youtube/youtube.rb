#### Create classes for YouTube resources.
module Youtube
  class Video < ActiveYoutube
    def entry
      if attributes.has_key?('entry')
        return attributes['entry']
      else
        [self]
      end
    end
    def method_missing(method_symbol, *args)
      method_name = method_symbol.to_s
      return attributes[method_name] if attributes.include?(method_name)
      return nil if known_attributes.include?(method_name)
      super
    end
  end

  class User < ActiveYoutube
  end

  class Standardfeed < ActiveYoutube
  end

  class Playlist < ActiveYoutube
  end
end
