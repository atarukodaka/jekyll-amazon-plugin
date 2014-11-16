# Amazon Tag Plugin for Jekyll

## How to install
### gems

    % vi Gemfile
    + gem 'amazon-ecs'
    + gem 'i18n'
    % bundle install --path /vendor/bundle

### amazon.rb

    % 

## How to use

    {% amazon <asin>:<template>l %}

e.g.

    {% amazon B0006HINCO:detail %}

## Configuring

```
% vi _config.yml
...
amazon:
  associate_tag: xxxx-22
  access_key_id: xxxx
  use_cache: true              # set false if you dont use cache
  cache_dir: _caches/amazon
```

Also, you can make customized-template as follows:

```
% vi _config.yml
...
amazon:
  ...
  templates:
    custom: |
      put your template here
```

hashes available:

- data    :title, :author, :publisher, ...
- labels  :author, :publisher  via i18n


## TODO

- i18n

## thanks to

- https://github.com/nitoyon/tech.nitoyon.com/blob/master/_plugins/tags/amazon.rb
- https://github.com/longkey1/jekyll-amazon-plugin

