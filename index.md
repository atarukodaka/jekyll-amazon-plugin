# Amazon Tag Plugin for Jekyll

## How to install
### get gems packages

    % vi Gemfile
    + gem 'amazon-ecs'
    + gem 'i18n'
    % bundle install --path /vendor/bundle

### get amazon.rb

    % git clone https://github.com/atarukodaka/jekyll-amazon-plugin.git

or

    % cd plugin
	% wget https://github.com/atarukodaka/jekyll-amazon-plugin/blob/master/amazon.rb

## How to use

    {% amazon <asin>:<template> %}

e.g.

    {% amazon B0006HINCO:detail %}

'title' and 'detail' are available as template. you can customize as you like (see below).

## Configuring

```
% vi _config.yml
...
amazon:
  associate_tag: xxxx-22
  access_key_id: xxxx
  secret_key: xxxx             # or set AMAZON_SECRET_KEY as Envirionment Value
  locale: ja                   # set blank if you dont use locale
  country: jp
  use_cache: true              # set false if you dont use cache
  cache_dir: _caches/amazon
```

### lables

    % vi locale/en.yml
	en:
	  author: 'author'
	  date: 'date'
	  publisher: 'publisher'

Also, you can make customized-template as follows:

```
% vi _config.yml
...
amazon:
  ...
  templates:
    custom: |
      put your template here on erb format
```

hashes available:

- data    :title, :author, :publisher, ...
- labels  :author, :publisher, :date  via i18n-locale


## TODO

- tbd

## Special Thanks to

- https://github.com/nitoyon/tech.nitoyon.com/blob/master/_plugins/tags/amazon.rb
- https://github.com/longkey1/jekyll-amazon-plugin

