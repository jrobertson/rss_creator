#!/usr/bin/env ruby

# file: rss_creator.rb

require 'dynarex'


class RSScreator

  attr_accessor :title, :desc, :limit

  def initialize(filepath=nil)

    @filepathpath = filepath
    @dx = Dynarex.new 'channel[title,desc]/item(title, link, description, created_at)'
    @dx.order = 'descending'
    @dx.xslt_schema = 'channel[title:title,description:desc]/' \
          + 'item(title:title,description:description,link:link,pubDate:created_at)'
    @dx.title, @dx.desc = '', ''

    # maxium number of items saved in the RSS feed
    @limit = 11

  end

  def add(item={title: '', link: '', description: ''})

    record = {created_at: Time.now.strftime("%a, %d %b %Y %H:%M:%S %z")}.\
                                                                    merge(item)
    @dx.create record
  end

  def save(new_filepath)

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

    if @title.nil? or @desc.nil? then
      raise 'RSScreator: title, or desc can\'t be blank' 
    end

    @dx.title, @dx.desc = @title, @desc
    @dx.to_rss({limit: @limit})

  end

end