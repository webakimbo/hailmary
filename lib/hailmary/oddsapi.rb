module OddsApi

  # http://jsonodds.com/documentation#sports
  class JsonOdds
    require 'rest-client'

    def source
      { url: base_uri, name: "JsonOdds" }
    end

    # def initialize(u, p)
    #   @auth = {:username => u, :password => p}
    # end

    # # which can be :friends, :user or :public
    # # options[:query] can be things like since, since_id, count, etc.
    # def timeline(which=:friends, options={})
    #   options.merge!({:basic_auth => @auth})
    #   self.class.get("/statuses/#{which}_timeline.json", options)
    # end

    # def post(text)
    #   options = { :body => {:status => text}, :basic_auth => @auth }
    #   self.class.post('/statuses/update.json', options)
    # end

    def odds
      begin
        RestClient.get "#{base_uri}/api/odds/nfl", headers
      rescue RestClient::ExceptionWithResponse => err
        # prob should return out of here
        err.response
      end
    end

    private

    def base_uri
      "https://jsonodds.com"
    end

    def headers
      { :accept => :json, :"JsonOdds-API-Key" => APP_CONFIG[:jsonodds_api_key] }
    end

  end

  # require 'rest-client'

  # RestClient.get 'http://example.com/resource'

  # RestClient.get 'http://example.com/resource', {:params => {:id => 50, 'foo' => 'bar'}}

  # RestClient.get 'https://user:password@example.com/private/resource', {:accept => :json}

  # RestClient.post 'http://example.com/resource', :param1 => 'one', :nested => { :param2 => 'two' }

  # RestClient.post "http://example.com/resource", { 'x' => 1 }.to_json, :content_type => :json, :accept => :json

  # RestClient.delete 'http://example.com/resource'

  # response = RestClient.get 'http://example.com/resource'
  # response.code
  # ➔ 200
  # response.cookies
  # ➔ {"Foo"=>"BAR", "QUUX"=>"QUUUUX"}
  # response.headers
  # ➔ {:content_type=>"text/html; charset=utf-8", :cache_control=>"private" ...
  # response.to_str
  # ➔ \n<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01//EN\"\n   \"http://www.w3.org/TR/html4/strict.dtd\">\n\n<html ....

  # RestClient.post( url,
  #   {
  #     :transfer => {
  #       :path => '/foo/bar',
  #       :owner => 'that_guy',
  #       :group => 'those_guys'
  #     },
  #      :upload => {
  #       :file => File.new(path, 'rb')
  #     }
  #   })

end
