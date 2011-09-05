#coding: utf-8
require "rubygems"
require "bundler/setup"
require "pit"
require "./event_tweet_agent"
require "./mixi_agent"

CONFIG = Pit.get("mixi_event_tweet", :require => {
  :mixi_login => "Mixi login",
  :mixi_password => "Mixi Password",
  :consumer_key => "Twitter Consumer Key",
  :consumer_secret => "Twitter Consumer Secret",
  :oauth_token_key => "Twitter OAuth Token",
  :oauth_token_secret => "Twitter OAuth Token Secret",
  :target_comm_id => "Mixi Community ID",
  :tweet_header => "Tweet Body Header"
})

agent = EventTweetAgent.new(CONFIG[:consumer_key], CONFIG[:consumer_secret], CONFIG[:oauth_token_key], CONFIG[:oauth_token_secret])
mixi_agent = MixiAgent.new
mixi_agent.mixi_login(CONFIG[:mixi_login], CONFIG[:mixi_password])
links = mixi_agent.get_community_event_links(CONFIG[:target_comm_id])

links.each do |link_node|
  event = mixi_agent.get_event link_node["href"]
  agent.tweet_event event, CONFIG[:tweet_header]
end
