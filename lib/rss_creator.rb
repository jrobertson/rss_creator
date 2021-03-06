#!/usr/bin/env ruby

# file: rss_creator.rb

require 'dynarex'
require 'rss_to_dynarex'


class RSScreator

  attr_accessor :title, :description, :link, :limit, :xslt, :image_url, 
      :image_target_url

  def initialize(filepath='rss.xml', dx_xslt: nil, dx_filename: 'feed.xml', 
                 custom_fields: [], limit: 10, debug: false)


    @filepath, @debug = filepath, debug

    dxfilepath = File.join(File.dirname(filepath), dx_filename)
    
    if filepath and File.exists? dxfilepath then

      @dx = Dynarex.new dxfilepath
      @title, @description, @link = @dx.title, @dx.description, @dx.link
      @image_url = @dx.image

    else
      if filepath and File.exists? filepath
      
        rtd = RSStoDynarex.new filepath
        @dx = rtd.to_dynarex

        @title, @description, @link = @dx.title, @dx.description, @dx.link
        @image_url = @dx.image if @dx.image and @dx.image.length > 1
        @image_target_url = @link if @link and @link.length > 1
      
      else

      
        schema = 'channel[title, description, link, image]/' + \
                                  'item(title, link, description, date'
        schema +=  ', ' + custom_fields.join(', ') if custom_fields.any?
        schema += ')'
        
        @dx = Dynarex.new schema
      end

      @dx.order = 'descending'    
      @dx.default_key = 'uid'
      @dx.xslt = dx_xslt if dx_xslt    

      
    end
    
    @dx.xslt_schema = 'channel[title:title,description:description,' + \
                    'link:link]/item(title:title,description:description,' + \
                                                      'link:link,pubDate:date)'
    # maxium number of items saved in the RSS feed
    @dx.limit = @limit = limit


    @dirty = true
    @dxfilename = dx_filename

  end

  def add(item: {title: '', link: '', description: ''}, id: nil)

    unless item[:title] and item[:link] then
      raise 'RSScreator: title or link can\'t be blank' 
    end
    
    record = {date: Time.now.strftime("%a, %d %b %Y %H:%M:%S %z")}.merge(item)
    @dx.create(record, id: id)
    
    @dirty = true
    
  end

  def save(new_filepath=nil)

    filepath = new_filepath ? new_filepath : @filepath
    File.write filepath, print_rss
    @dx.save File.join(File.dirname(filepath), @dxfilename) if @dxfilename
  end
  
  def description=(val)
    @description = val
    @dirty = true
  end
  
  def delete(id)
    @dx.delete id.to_s
  end

  alias desc= description=
  alias desc description

  def dynarex()
    @dx
  end
  
  def image_url=(val)
    @image_url = val
    @dirty = true
  end
  
  alias image= image_url=
  
  def image_target_url=(val)
    @image_target_url = val
    @dirty = true
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
    @dx.image = @image_url if @dx.respond_to? :image
    
    @rss = if @xslt then
    
      @dx.to_rss({limit: @limit}) do |doc|
        
        doc.instructions << ['xml-stylesheet',\
          "title='XSL_formatting' type='text/xsl' href='#{@xslt}'"]
        
      end      
      
    else
      
      @dx.to_rss({limit: @limit}) do |doc|
        
        if @image_url then
          
          img = Rexle::Element.new('image')
          img.add Rexle::Element.new('url').add_text @image_url
          img.add Rexle::Element.new('link').add_text @image_target_url
        
          doc.root.element('channel/item').insert_before img
        
        end        
        
      end
      
    end
    
    @dirty = false
    @rss

  end

end
