#--
# Copyright(C) 2015 Giovanni Capuano <webmaster@giovannicapuano.net>
#
# Redistribution and use in source and binary forms, with or without modification, are
# permitted provided that the following conditions are met:
#
#    1. Redistributions of source code must retain the above copyright notice, this list of
#       conditions and the following disclaimer.
#
# THIS SOFTWARE IS PROVIDED BY Giovanni Capuano ''AS IS'' AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
# FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Giovanni Capuano OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# The views and conclusions contained in the software and documentation are those of the
# authors and should not be interpreted as representing official policies, either expressed
# or implied, of Giovanni Capuano.
#++

module Zanox
  module API
    module Session
      class << self
        attr_accessor :connect_id
        attr_accessor :secret_key

        def fingerprint_of(method, options, verb = 'GET')
          method = method[0] == '/' ? method : "/#{method}"

          timestamp = get_timestamp
          nonce     = get_nonce
          signature = create_signature(Session.secret_key, "#{verb}#{method.downcase}#{timestamp}#{nonce}")
          [timestamp, nonce, signature]
        end

        private
        def get_timestamp
          Time.now.strftime('%a, %e %b %Y %T %Z')
        end

        def get_nonce
          Digest::MD5.hexdigest((Time.new.usec + rand()).to_s)
        end

        def create_signature(secret_key, string_to_sign)
          digest = OpenSSL::HMAC.digest('sha1', secret_key, string_to_sign)
          Base64.encode64(digest)[0..-2]
        end
      end
    end
  end
end
