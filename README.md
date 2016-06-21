# UZ::API

[![Code Climate][codeclimate_badge]][codeclimate]

A Ruby interface to the Ukrzaliznytsia API (http://booking.uz.gov.ua/)

To experiment with that code, run `bin/console` for an interactive prompt.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'uz-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install uz-api

## Usage

Initialize new instance of `UZ::API`

```ruby
uz = UZ::API.new
```

### Search stations

```ruby
uz.search_stations('Тернопіль')
# => [{"title"=>"Тернопіль", "station_id"=>"2218300"}]

uz.search_stations('Київ')
# => [{"title"=>"Київ", "station_id"=>"2200001"}, {"title"=>"Київська Русанівка", "station_id"=>"2201180"}]
```

### Search trains

```
# search_trains(station_id_from, station_id_to, date_dep, time_dep='00:00')
uz.search_trains('2218300', '2200001', '22.06.2016')
```

In response, we get a list of trains running on the specified route. Also, in response will include information about the number of empty seats:

```
[{"num"=>"050Л",
  "model"=>0,
  "category"=>0,
  "travel_time"=>"6:24",
  "from"=>
   {"station_id"=>2218300,
    "station"=>"Трускавець",
    "date"=>1466546400,
    "src_date"=>"2016-06-22 01:00:00"},
  "till"=>
   {"station_id"=>2200001,
    "station"=>"Київ-Пасажирський",
    "date"=>1466569440,
    "src_date"=>"2016-06-22 07:24:00"},
  "types"=>
   [{"title"=>"Люкс", "letter"=>"Л", "places"=>3},
    {"title"=>"Купе", "letter"=>"К", "places"=>34}],
  "reserve_error"=>"reserve_24h"},
 {"num"=>"748К",
  "model"=>4,
  "category"=>2,
  "travel_time"=>"5:37",
  "from"=>
   {"station_id"=>2218300,
    "station"=>"Тернопіль",
    "date"=>1466597640,
    "src_date"=>"2016-06-22 15:14:00"},
  "till"=>
   {"station_id"=>2200001,
    "station"=>"Дарниця",
    "date"=>1466617860,
    "src_date"=>"2016-06-22 20:51:00"},
  "types"=>
   [{"title"=>"Сидячий першого класу", "letter"=>"С1", "places"=>92},
    {"title"=>"Сидячий другого класу", "letter"=>"С2", "places"=>139}]},
 {"num"=>"112Л",
  "model"=>0,
  "category"=>0,
  "travel_time"=>"8:01",
  "from"=>
   {"station_id"=>2218300,
    "station"=>"Львів",
    "date"=>1466610600,
    "src_date"=>"2016-06-22 18:50:00"},
  "till"=>
   {"station_id"=>2200001,
    "station"=>"Харків-Пас",
    "date"=>1466639460,
    "src_date"=>"2016-06-23 02:51:00"},
  "types"=>[{"title"=>"Люкс", "letter"=>"Л", "places"=>5}]}]
```

### List of coaches and the number of free places

```
# search_coaches(station_id_from, station_id_to, train, model, coach_type, date_dep)
uz.search_coaches('2218300', '2200001', '748К', 4, 'С2', '1466546400')
```

In response, we get a list of coaches of this type with the number of free places and the price

```
{"coach_type_id"=>14,
 "coaches"=>
  [{"num"=>2,
    "type"=>"С",
    "allow_bonus"=>false,
    "places_cnt"=>49,
    "has_bedding"=>false,
    "reserve_price"=>1700,
    "services"=>[],
    "prices"=>{"А"=>22990},
    "coach_type_id"=>14,
    "coach_class"=>"2"},
   {"num"=>3,
    "type"=>"С",
    "allow_bonus"=>false,
    "places_cnt"=>34,
    "has_bedding"=>false,
    "reserve_price"=>1700,
    "services"=>[],
    "prices"=>{"А"=>22990},
    "coach_type_id"=>14,
    "coach_class"=>"2"},
   {"num"=>4,
    "type"=>"С",
    "allow_bonus"=>false,
    "places_cnt"=>56,
    "has_bedding"=>false,
    "reserve_price"=>1700,
    "services"=>[],
    "prices"=>{"А"=>22990},
    "coach_type_id"=>14,
    "coach_class"=>"2"}],
 "places_allowed"=>8,
 "places_max"=>8}
```

### View availability:

```
# show_coach(station_id_from, station_id_to, train, coach_num, coach_class, coach_type_id, date_dep)
uz.show_coach('2218300', '2200001', '748К', 2, '2', 25, '1466546400')
```

In response, we get a list of available seats

```
{"places"=>
  {"А"=>
    ["4",
     "5",
     "6",
     "8",
     "9",
     "10",
     "14",
     "20",
     "27",
     "90",
     "92",
     "93"]}}
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/uz-api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


[codeclimate_badge]: http://img.shields.io/codeclimate/github/mamantoha/uz-api.svg?style=flat
[codeclimate]: https://codeclimate.com/github/mamantoha/uz-api
