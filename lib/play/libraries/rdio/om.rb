# om is oauth-mini - a simple implementation of a useful subset of OAuth.
# It's designed to be useful and reusable but not general purpose.
#
# (c) 2011 Rdio Inc
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# A simple OAuth client implementation. Do less better.
# Here are the restrictions:
#   - only HMAC-SHA1 is supported
#   - only WWW-Authentiate form signatures are generated
#
# To sign a request:
#   auth = om([consumer_key,consumer_secret], url, params)
#     send Authorization: <auth>
#     when POSTing <params> to <url>
# Optional additional arguments are:
#   token = [oauth_token, oauth_token_secret]
#   method = "POST"
#   realm = "Realm-for-authorization-header"

#import time, random, hmac, hashlib, urllib, binascii, urlparse

require 'uri'
require 'cgi'
require 'digest'
require 'digest/sha1'

module Play
  module Rdio
    extend self
    
    def om(consumer, url, post_params, token=nil, method='POST', realm=nil, timestamp=nil, nonce=nil)
      # A one-shot simple OAuth signature generator

      # the method must be upper-case
      method = method.upcase

      # we want params as an Array of name / value pairs
      if post_params.is_a?(Array)
        params = post_params
      else
        params = post_params.collect { |x| x }
      end

      # normalize the URL
      url = URI.parse(url)
      # scheme is lower-case
      url.scheme = url.scheme.downcase
      # remove username & password
      url.user = url.password = nil
      # host is lowercase
      url.host = url.host.downcase

      # add URL params to the params
      if url.query
        CGI.parse(url.query).each { |k,vs| vs.each { |v| params.push([k,v]) } }
      end

      # remove the params and fragment
      url.query = nil
      url.fragment = nil

      # add OAuth params
      params = params + [
        ['oauth_version', '1.0'],
        ['oauth_timestamp', timestamp || Time.now.to_i.to_s],
        ['oauth_nonce', nonce || rand(1000000).to_s],
        ['oauth_signature_method', 'HMAC-SHA1'],
        ['oauth_consumer_key', consumer[0]],
      ]

      # the consumer secret is the first half of the HMAC-SHA1 key
      hmac_key = consumer[1] + '&'

      if token != nil
        # include a token in params
        params.push ['oauth_token', token[0]]
        # and the token secret in the HMAC-SHA1 key
        hmac_key += token[1]
      end

      def percent_encode(s)
        chars = s.to_s.chars.map do |c|
          if ((c >= '0' and c <= '9') or
              (c >= 'A' and c <= 'Z') or
              (c >= 'a' and c <= 'z') or
              c == '-' or c == '.' or c == '_' or c == '~')
            c
          else
            '%%%02X' % c.unpack('c')
          end
        end
        chars.join
      end

      # Sort lexicographically, first after key, then after value.
      params.sort!
      # escape the key/value pairs and combine them into a string
      normalized_params = (params.collect {|p| percent_encode(p[0])+'='+percent_encode(p[1])}).join '&'

      # build the signature base string
      signature_base_string = (percent_encode(method) +
                               '&' + percent_encode(url.to_s) +
                               '&' + percent_encode(normalized_params))

      # HMAC-SHA1
      hmac = Digest::HMAC.new(hmac_key, Digest::SHA1)
      hmac.update(signature_base_string)

      # Calculate the digest base 64. Drop the trailing \n
      oauth_signature = [hmac.digest].pack('m0').strip

      # Build the Authorization header
      if realm
        authorization_params = [['realm', realm]]
      else
        authorization_params = []
      end
      authorization_params.push(['oauth_signature', oauth_signature])

      # we only want certain params in the auth header
      oauth_params = ['oauth_version', 'oauth_timestamp', 'oauth_nonce',
                      'oauth_signature_method', 'oauth_signature',
                      'oauth_consumer_key', 'oauth_token']
      authorization_params.concat(params.select { |param| nil != oauth_params.index(param[0]) })

      return 'OAuth ' + (authorization_params.collect {|param| '%s="%s"' % param}).join(', ')
    end
  end
end