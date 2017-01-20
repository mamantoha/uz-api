require 'json'
require 'mechanize'
require 'jjdecoder'
require 'byebug'
require 'uz/api/version'
require 'uz/api/methods'

module UZ
  class APIError < ArgumentError; end
  class TokenError < ArgumentError; end

  class API
    attr_reader :token

    JJ_ENCODE_PATTERN = /0\);}\);(.+)<\/script>/i
    TOKEN_PATTERN = /localStorage.setItem\(\"gv-token\", \"(\w+)\"\);/i

    # Create a new API object using the given parameters
    #
    def initialize
      @api_url = 'http://booking.uz.gov.ua'
      @agent = Mechanize.new

      get_token
      set_headers
    end

    # Shuts down this session by clearing browsing state and create
    # a new Mechanize instance with new token
    #
    def refresh_token
      @agent.shutdown
      @agent = Mechanize.new

      get_token
      set_headers
    end

    def inspect
      "#<#{self.class.name}:#{"0x00%x" % (object_id << 1)} @token=\"#{@token}\">"
    end

    private

    def get_token
      resp = @agent.get(@api_url)

      jj_code = JJ_ENCODE_PATTERN.match(resp.body)[1]
      jj_decoder = JJDecoder.new(jj_code)
      jj_decoded = jj_decoder.decode

      @token = TOKEN_PATTERN.match(jj_decoded)[1]
    end

    def set_headers
      headers = {
        'GV-Ajax'    => 1,
        'GV-Referer' => @api_url,
        'GV-Screen'  => '1920x1080',
        'GV-Token'   => @token
      }
      @agent.request_headers = headers
    end

  end
end
