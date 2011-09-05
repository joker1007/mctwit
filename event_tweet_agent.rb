#coding: utf-8
require "rubygems"
require "bundler/setup"
require "twitter"
require "kconv"

class EventTweetAgent
  def initialize(consumer_key, consumer_secret, oauth_token, oauth_token_secret)
    Twitter.configure do |config|
      config.consumer_key = consumer_key
      config.consumer_secret = consumer_secret
      config.oauth_token = oauth_token
      config.oauth_token_secret = oauth_token_secret
    end

    @client = Twitter::Client.new
  end

  def tweet_event(event, header = nil)
    if event.schedule > Time.now
      tweet_body = ""
      tweet_body += "#{header} " if header
      tweet_body += "#{event.schedule.strftime("%Y/%m/%d")} #{event.title}"

      if tweet_body.length < 100
        offset = 110 - tweet_body.length
        desc = event.body[0..offset] + "..."
        tweet_body += " - #{desc}"
      end

      tweet_body += " http://mixi.jp/#{event.link}"

      @client.update(tweet_body)
    end
  end
end
