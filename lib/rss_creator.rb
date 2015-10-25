#!/usr/bin/env ruby

# file: rss_creator.rb

require 'dynarex'
require 'rss_to_dynarex'


class RSScreator

  attr_accessor :title, :description, :limit

  def initialize(filepath=nil)

    @filepath = filepath
    
    if filepath then
      
      rtd = RSStoDynarex.new filepath
      @dx = rtd.to_dynarex      
      @title = @dx.title
      @description = @dx.description
      
    else
      @dx = Dynarex.new 'channel[title,description]/item(title, link, description, created_at)'
      @dx.order = 'descending'
    end
        
    @dx.xslt_schema = 'channel[title:title,description:description]/' \
          + 'item(title:title,description:description,link:link,pubDate:created_at)'


    # maxium number of items saved in the RSS feed
    @limit = 11

  end

  def add(item={title: '', link: '', description: ''})

    record = {created_at: Time.now.strftime("%a, %d %b %Y %H:%M:%S %z")}.\
                                                                    merge(item)
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

    if @title.nil? or @description.nil? then
      raise 'RSScreator: title, or description can\'t be blank' 
    end

    @dx.title, @dx.description = @title, @description
    @dx.to_rss({limit: @limit})

  end

end