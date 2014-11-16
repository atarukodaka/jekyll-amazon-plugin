# Amazon Tag Plugin for Jekyll

## How to install
### get gems packages

    % vi Gemfile
    ...
	gem 'amazon-ecs'
    gem 'i18n'
    % bundle install --path /vendor/bundle

### get this plugin

by git-submodule

    % git submodule add https://github.com/atarukodaka/jekyll-amazon-plugin.git _plugins/amazon

or

    % cd _plugins
	% wget https://github.com/atarukodaka/jekyll-amazon-plugin/blob/master/amazon.rb

## How to use
### Syntax
in your post or page, put text like:

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

## Customization
### lables

    % vi locale/en.yml
	en:
	  author: 'author'
	  date: 'date'
	  publisher: 'publisher'

### template

```
% vi _config.yml
...
amazon:
  ...
  templates:
    custom: |
      put your template here on erb format
```

hashes are available:

- data    :title, :author, :publisher, :date
- labels  :author, :publisher, :date  via i18n-locale

## TODO

- docs
- css

## Special Thanks to

- https://github.com/nitoyon/tech.nitoyon.com/blob/master/_plugins/tags/amazon.rb
- https://github.com/longkey1/jekyll-amazon-plugin

