require 'fakeweb'

module FakewebHelper
  # Make sure nothing gets out (IMPORTANT)
  FakeWeb.allow_net_connect = false

  # Turns a fixture file name into a full path
  def fixture_file(filename)
    return '' if filename == ''
    "#{SimpleYoutube::ROOT}/spec/fixture/#{filename}"
  end

  # Convenience methods for stubbing URLs to fixtures
  def stub_get(url, filename)
    FakeWeb.register_uri(:get, url, :response => fixture_file(filename))
  end

  def stub_http_error(http_type, url, error_code, error_message)
    FakeWeb.register_uri(http_type, url, :status => [error_code, error_message])
  end

end