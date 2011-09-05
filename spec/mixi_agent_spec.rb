# coding: utf-8
require "rubygems"
require "bundler/setup"
require "rspec"

require File.join(File.dirname(__FILE__), "../mixi_agent")

describe MixiAgent do
  let(:agent) {MixiAgent.new}

  it "#mixi_login(id, pass)でログインできる" do
    agent.mixi_login
    agent.page.body.should =~ /Jomang/
  end
end
