#
# This module provides the interface for a response object to have
# a #entry method regardless of the response object being a single
# entry or a collection of entries
#
module EntryInterfaceShim
  def entry
    if attributes.has_key?('entry')
      if attributes['entry'].kind_of? Array
        return attributes['entry']
      else
        return [attributes['entry']]
      end
    else
      [self]
    end
  end
end