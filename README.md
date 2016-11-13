# TodoBot

TodoBot can do your to do lists, links and other information.
You can add it to your chat or group and see it in action. https://telegram.me/todobot

## Installation

```ruby
  cp config/database.yml.example config/database.yml
  vi config/database.yml
  cp config/settings.yml.example config/settings.yml
  # required attributes: bot_name и token
  vi config/settings.yml
  docker-compose build
  docker-compose up -d db
  docker-compose run --rm app rake db:setup
  docker-compose run --rm -e BOT_ENV=test app rake db:setup
```

## Start

```ruby
  docker-compose up
```

## Tests

```ruby
  docker-compose run --rm app rspec
```

## Commands

| Commands  | Description |
| ------------- | ------------- |
| /create, /newlist | Create to do list |
| /todo, /task, /t | Create task |
| /list, /l | See all current tasks |
| /lists, /ls | See all lists |
