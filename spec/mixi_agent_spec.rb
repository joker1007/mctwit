# coding: utf-8
require "rubygems"
require "bundler/setup"
require "rspec"
require "pit"
require "kconv"

require File.join(File.dirname(__FILE__), "../mixi_agent")

CONFIG = Pit.get("mctwit", :require => {:username => "Mixi Account", :password => "Mixi Password", :cid => "Community ID"})

describe MixiAgent do
  let(:agent) {MixiAgent.new}

  it "#mixi_login(id, pass)" do
    agent.mixi_login(CONFIG[:username], CONFIG[:password])
    agent.page.body.toutf8.should =~ /ログアウト/
  end

  context "Mixi logined" do
    before do
      agent.mixi_login(CONFIG[:username], CONFIG[:password])
    end

    it "#get_community_event_list(cid)" do
      events = agent.get_community_event_links CONFIG[:cid]
      events.should have(7).items
      events.each do |e|
        e["href"].should =~ /view_event\.pl/
      end
    end

    it "#get_event(link)" do
      events = agent.get_community_event_links CONFIG[:cid]
      e = agent.get_event events[0]["href"]
      p e
    end
  end

end
