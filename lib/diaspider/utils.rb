require 'addressable/uri'

module Diaspider
  module Utils
    extend self

    ##
    # Sometimes URLs are relative, e.g. "index.html" as opposed to "http://site.com/index.html"
    # so, resolve_url resolves them to absolute urls.
    #
    # (this is mostly a port of a method I wrote for propublica/upton and likely misses edge
    #  cases that I hadn't thought of)

    # :href, using http://www.propublica.org/hello/world.html, [resolves to] => return_value 
    # ----------------------------------
    # [empty string]  => http://www.propublica.org/hello/world.html
    # "you.html"    => http://www.propublica.org/hello/you.html
    # "/goodbye"      => http://www.propublica.org/goodbye
    # "?q=1"          => http://www.propublica.org/hello/world.html?q=1
    # "https://othersite.com" =>  https://othersite.com
    # "//othersite.com"       =>  http://othersite.com

    # As a (hopefully desired) side-effect, it normalizes URIs according to spec, via Addressable::URI
    #
    # 'http://WwW.ExaMPLE.com' => 'http://www.example.com'
    # 'http://www.example.com/you and me' => 'http://www.example.com/you%20and%20me'
    

    # Arguments:
    # :abs_url(String or Addressable::URI) must be, well, absolute. In real-world use case, it
    #  represents the webpage, e.g. the reference point, from which a URI (href) of unknown absoluteness must be evaluated against
    #
    # :a_href(String or Addressable::URI) is any kind of URI, relative or absolute, that you want to make
    #  absolute
    #
    #
    # returns:
    #  a String of the absolute URL
    def resolve_url(a_href, abs_url)
      raise ArgumentError, 'Cannot have nil as values' if a_href.nil? || abs_url.nil?

      absolute_url = Addressable::URI.parse(abs_url).normalize rescue raise( ArgumentError, ":abs_url must be a String or URI")
      raise ArgumentError, "#{absolute_url} must be absolute" unless absolute_url.absolute?
      href = Addressable::URI.parse(a_href).normalize rescue raise( ArgumentError, ":a_href must be a String or URI")
      # return :href if :href is already absolute
      return href.to_s if href.absolute?

      return absolute_url.join(href).to_s
    end
  end
end