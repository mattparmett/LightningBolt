# LightningBolt - Centroid-based Autosummarization #

I miss Microsoft Word's Autosummarize feature.  I don't know why they removed it from Word 2010.  LightningBolt is a (very rudimentary, at this point) Ruby library that pays homage to ![lightning bolt](http://mattparmett.com/img/as.png) by conducting unsupervised centroid-based autosummarization on plaintext files.

## How to use LighningBolt ##

```ruby
include "./lightningbolt.rb"
as = LightningBolt.new("file.txt")
summary = as.summary([filter_strength])
```

You can also directly tell LightningBolt to give you the summary:

```ruby
include "./lightningbolt.rb"
summary = LightningBolt.summarize(file_path, filter_strength)
```

```filter_strength``` is a float that tells LightningBolt how strict to be while autosummarizing.  Higher ```filter_strength``` values yield shorter summaries.

The second method is quicker, but doesn't give you access to word/sentence lists, centroid scores, etc.  Additionally, there may be more functionality added to LightningBolt that won't necessarily be available without creating a LightningBolt instance.