#coding: utf-8
require "rubygems"
require "bundler/setup"
require "mechanize"
require "kconv"

class MixiAgent < Mechanize
  def mixi_login(login, password)
    get "http://mixi.jp/home.pl"
    login_form = page.form_with(:name => "login_form")
    login_form.field_with(:name => "email").value = login
    login_form.field_with(:name => "password").value = password
    submit(login_form)
    get "http://mixi.jp/home.pl"
  end

  def get_community_event_links(cid)
    get "http://mixi.jp/view_community.pl?id=#{cid}"
    links = page.parser.css("#newCommunityEvent .contents dd a")
  end

  def get_event(link)
    get link
    parser = page.parser
    mixi_event = MixiEvent.new
    mixi_event.link = link
    event_id, cid = link.scan(/id=(\d+).*comm_id=(\d+)/).flatten
    mixi_event.event_id = event_id.to_i
    mixi_event.cid = cid.to_i

    title_node = parser.css("span.title").first
    mixi_event.title = title_node.content

    date_node = parser.css("span.date").first
    year, month, day, hour, min = date_node.content.scan(/(\d{4})[^\d]*(\d{2})[^\d]*(\d{2})[^\d]*(\d{2}):(\d{2})/).flatten
    mixi_event.created_at = Time.local(year, month, day, hour, min)

    hold_node = parser.css(".bbsList01 .bbsInfo dd").first
    year, month, day = hold_node.content.scan(/(\d{4})[^\d]*(\d{2})[^\d]*(\d{2})/).flatten
    mixi_event.schedule = Time.local(year, month, day)

    body_node = parser.css(".bbsList01 .bbsContent dd").first
    mixi_event.body = body_node.content

    mixi_event
  end
end

class MixiEvent
  attr_accessor :title, :body, :link, :created_at, :event_id, :cid, :schedule
end
