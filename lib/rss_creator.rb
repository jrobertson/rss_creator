#!/usr/bin/env ruby

# file: rss_creator.rb

require 'dynarex'
require 'rss_to_dynarex'


class RSScreator

  attr_accessor :title, :description, :link, :limit

  def initialize(filepath=nil)

    @filepath = filepath
    
    if filepath and File.exists? filepath then
      
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
    @dirty = true    

  end

  def add(item={title: '', link: '', description: ''})
    
    unless item[:title] and item[:link] then
      raise 'RSScreator: title or link can\'t be blank' 
    end
    
    record = {date: Time.now.strftime("%a, %d %b %Y %H:%M:%S %z")}.merge(item)
    @dx.create record
    
    @dirty = true
    
  end

  def save(new_filepath=nil)

    filepath = new_filepath ? new_filepath : @filepath
    File.write filepath, print_rss
  end
  
  def description=(val)
    @description = val
    @dirty = true
  end  

  def dynarex()
    @dx
  end

  def link=(val)
    @link = val
    @dirty = true
  end  
  
  def title=(val)
    @title = val
    @dirty = true
  end

  def to_s()
    print_rss
  end

  private

  def print_rss()
    
    return @rss unless @dirty

    if @title.nil? or @description.nil?  then
      raise 'RSScreator: title or description can\'t be blank' 
    end

    @dx.title, @dx.description, @dx.link = @title, @description, @link || ''
    @rss = @dx.to_rss({limit: @limit})
    @dirty = false
    @rss

  end

end