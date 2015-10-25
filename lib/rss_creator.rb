#!/usr/bin/env ruby

# file: rss_creator.rb

require 'dynarex'
require 'rss_to_dynarex'


class RSScreator

  attr_accessor :title, :description, :link, :limit

  def initialize(filepath=nil)

    @filepath = filepath
    
    if filepath then
      
      rtd = RSStoDynarex.new filepath
      @dx = rtd.to_dynarex      
      @title = @dx.title
      @description = @dx.description
      @link = @dx.link
      
    else
      @dx = Dynarex.new 'channel[title, description, link]/' + \
                                         'item(title, link, description, date)'
      @dx.order = 'descending'
    end
        
    @dx.xslt_schema = 'channel[title:title,description:description,' + \
                    'link:link]/item(title:title,description:description,' + \
                                                      'link:link,pubDate:date)'
    # maxium number of items saved in the RSS feed
    @limit = 11

  end

  def add(item={title: '', link: '', description: ''})

    unless item[:title] and item[:link] then
      raise 'RSScreator: title or link can\'t be blank' 
    end
    
    record = {date: Time.now.strftime("%a, %d %b %Y %H:%M:%S %z")}.merge(item)
    @dx.create record
  end

  def save(new_filepath=nil)

    filepath = new_filepath ? new_filepath : @filepath
    File.write filepath, print_rss
  end

  def dynarex()
    @dx
  end

  def to_s()
    print_rss
  end

  private

  def print_rss()

    if @title.nil? or @description.nil?  then
      raise 'RSScreator: title or description can\'t be blank' 
    end

    @dx.title, @dx.description, @dx.link = @title, @description, @link || ''
    @dx.to_rss({limit: @limit})

  end

end