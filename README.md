# Introducing the RSS_creator gem

    require 'rss_creator'

    rss = RSScreator.new

    rss.title = 'The Edinburgh Weather forecast feed'
    rss.desc = 'Weather data fetched from forecast.io'

    item = {
      title: 'Tuesday: Drizzle in the morning', 
      link: 'http://www.yourwebsite.com/2015/oct/24/#8am',
      description: 'In the east of Edinburgh, drizzle is expected in the ' + \
                          'morning with a minimum temperature of 6 degrees Celcius'
    }
    rss.add item
    rss.save 'feed.rss'

Output:

<pre>
&lt;?xml version='1.0' encoding='UTF-8'?&gt;
&lt;rss version='2.0'&gt;
  &lt;channel&gt;
    &lt;title&gt;The Edinburgh Weather forecast feed&lt;/title&gt;
    &lt;description&gt;Weather data fetched from forecast.io&lt;/description&gt;
    &lt;item&gt;
      &lt;title&gt;Tuesday: Drizzle in the morning&lt;/title&gt;
      &lt;description&gt;In the east of Edinburgh, drizzle is expected in the morning 
with a minimum temperature of 6 degrees Celcius&lt;/description&gt;
      &lt;link&gt;http://www.yourwebsite.com/2015/oct/24/#8am&lt;/link&gt;
      &lt;pubDate&gt;Sat, 24 Oct 2015 22:40:10 +0100&lt;/pubDate&gt;
    &lt;/item&gt;
  &lt;/channel&gt;
&lt;/rss&gt;
</pre>

## Resources

* rss_creator https://rubygems.org/gems/rss_creator

rss_creator rss dynarex gem
