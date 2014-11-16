################################################################
# _plubing/amazon.rb

require 'amazon/ecs'
require 'erb'
require 'i18n'

$debug = false

################################################################
module Jekyll
  class AmazonTag
    include ERB::Util
    
    @@templates = {
      title: %(<span><a href="<%= data[:detail_url] %>" target="_blank"><%= data[:title] %></a></span>),
      detail:
%(
<div class="amazon_item">
<a href="<%= data[:detail_url] %>" target="_blank"><img src="<%= data[:image_medium] %>"></a>
<a href="<%= data[:detail_url] %>" target="_blank"><%= data[:title] %></a><br>
<% labels.keys.each do |t| %>
 <% if data[t] != "" %>
  <%= labels[t] %>: <%= data[t]%> <br>
 <% end %>
<% end %>
</div>)
    }
    def initialize(name, params, token)
      params.strip =~ /^(\w+):?(\w+)$/
      @asin = $1
      @template_type = $2 || 'title'
    end

    def render(context)
      conf = get_config(context, 'amazon')

      # cache
      use_cache = (conf['use_cache'].to_s =~ /true/i) ? true : false
      dputs "use_cache: #{conf['use_cache']} / #{use_cache}"

      if use_cache
        cache = Jekyll::AmazonCache.new(conf['cache_dir'])
        data = cache.get(@asin)
      end
      if data.nil?
        Amazon::Ecs.options= {
          associate_tag: conf['associate_tag'],
          AWS_access_key_id: conf['access_key_id'],
          AWS_secret_key: conf['secret_key'] || ENV['AMAZON_SECRET_KEY'],
          country: conf['country'] || 'jp',
          response_group: 'Images,ItemAttributes'
        }
        data = item_lookup(@asin)
        cache.put(@asin, data) if use_cache
      end

      # template
      if conf['templates'].class == Hash
        conf['templates'].each do |key, value|
          @@templates[key.to_sym] = value
        end
      end
      return "(invalid template type: #{h @template_type})" unless @@templates.key? @template_type.to_sym

      # labels
      label_items = [:author, :publisher, :date]
      labels = {}

      if conf['locale'].to_s == ""  # locale NOT specified
        label_items.map {|item| labels[item] = item.to_s}
      else
        dputs " locale: #{conf['locale']}"
        locale = conf['locale'].to_sym || "ja"
        I18n.enforce_available_locales = false
        I18n.locale = locale.to_sym
        I18n.load_path = [File.expand_path(File.dirname(__FILE__)) + "/locale/#{locale}.yml"]
        label_items.map {|item| labels[item] = I18n.t(item.to_s)}
      end

      # render
      erb = ERB.new(@@templates[@template_type.to_sym])
      erb.result(binding)
    end

    ################
    def get_config(context, item = "amazon")
      context.registers[:site].config[item]
    end
    def item_lookup(asin)
      cnt = 0
      begin
        dputs "looking-up #{asin}..."
        res = Amazon::Ecs.item_lookup(asin)
      rescue Amazon::RequestError => err
        if /503/ =~ err.message && cnt < 3
          sleep 3
          cnt += 1
          dputs "  retrying...#{asin}/#{cnt}"
          dputs "    options: #{Amazon::Ecs.options.inspect}"
          retry
        else
          raise err
        end
      end

      data = nil
      res.items.each do |item|
        data = {
          asin:        asin,
          title:       item.get('ItemAttributes/Title').to_s,
          author:      item.get('ItemAttributes/Author').to_s,
          publisher:   item.get('ItemAttributes/Manufacturer').to_s,
          date:        item.get('ItemAttributes/PublicationDate').to_s || 
                       item.get('ItemAttributes/ReleaseDate').to_s,
          detail_url:  item.get('DetailPageURL').to_s,

          image_small: item.get('SmallImage/URL').to_s,
          image_medium: item.get('MediumImage/URL').to_s,
          image_large: item.get('LargeImage/URL').to_s,
        }
      end
      return data
    end
  end
  ################################################################
  class AmazonCache
    def initialize(cache_dir = "./_caches/amazon")
      @cache_dir = cache_dir
      if File.exists?(@cache_dir) == false
        dputs "mkpath: #{@cache_dir}"
        FileUtils.mkpath(@cache_dir) 
      end
    end
    def cache_filename(asin)
      File.join(@cache_dir, asin)
    end
    def get(asin)
      if File.exists?(cache_filename(asin))
        dputs "get cache '#{asin}' from #{cache_filename(asin)}"
        return Marshal.load(File.read(cache_filename(asin)))
      else
        dputs "no cache for #{asin}"
        return nil
      end
    end
    def put(asin, data)
      dputs "saving cache '#{asin}' into #{cache_filename(asin)}"
      open(cache_filename(asin), 'w'){|f|
        f.write(Marshal.dump(data))
      }
      return data
    end
  end
end


Liquid::Template.register_tag('amazon', Jekyll::AmazonTag)

################################################################
# for debug

def dputs(str)
  debug = true
  puts str if $debug
end

