module UZ
  class API
    # Example:
    #   uz = UZ::API.new
    #
    #   uz.search_stations('Тернопіль')
    #   # => [{"title"=>"Тернопіль", "station_id"=>"2218300"}]
    #
    #   uz.search_stations('Kmdsd')
    #   # => [{"title"=>"Львів", "station_id"=>"2218000"}, {"title"=>"Львівська", "station_id"=>"2000615"}]
    #
    #   # Search trains from Ternopil to Lviv on 21.06.2016
    #   uz.search_trains('2218300', '2218000', '21.06.2016')
    #
    #   # Show coaches with type "Плацкарт" in train number "136Ш" from Ternopil to Lviv on 21.06.2016
    #   # Note: Date.parse('21.06.2016').to_time.to_i # => Date.parse('21.06.2016').to_time.to_i
    #   uz.search_coaches('2218300', '2218000', '136Ш', 'П', '1466465400')
    #
    #   # Show places in coach
    #   uz.show_coach('2218300', '2218000', '136Ш', '16', 'Б', 4, '1466465400')

    # Search stations by name
    #
    def search_stations(str)
      path = "/purchase/station/#{str}/"
      resp = request(path)
      data = parse_response(resp)

      data['value']
    end

    # Form data:
    #   station_id_from: '2218000',
    #   station_id_till: '2218300',
    #   station_from: 'Львів',
    #   station_till: 'Тернопіль',
    #   date_dep: '20.06.2016',
    #   time_dep: '00:00',
    #   time_dep_till:'',
    #   another_ec: '0',
    #   search: ''
    #
    # Returns array of trains.
    # Each train represet as above:
    #   {
    #     "num"=>"136Ш",
    #     "model"=>0,
    #     "category"=>0,
    #     "travel_time"=>"2:17",
    #     "from"=>{
    #       "station_id"=>2218300,
    #       "station"=>"Одеса-Головна",
    #       "date"=>1466465400,
    #       "src_date"=>"2016-06-21 02:30:00"
    #     },
    #     "till"=>{
    #       "station_id"=>2218000,
    #       "station"=>"Чернівці",
    #       "date"=>1466473620,
    #       "src_date"=>"2016-06-21 04:47:00"
    #     },
    #     "types"=>[
    #       {
    #         "title"=>"Люкс",
    #         "letter"=>"Л",
    #         "places"=>2
    #       },
    #       {
    #         "title"=>"Купе",
    #         "letter"=>"К",
    #         "places"=>2
    #       },
    #       {
    #         "title"=>"Плацкарт",
    #         "letter"=>"П",
    #         "places"=>3
    #       }
    #     ],
    #     "reserve_error"=>"reserve_24h"
    #   }
    #
    def search_trains(station_id_from, station_id_to, date_dep, time_dep='00:00')
      # date_dep = date_dep.strftime('%d.%m.%Y')

      path = '/purchase/search/'
      payload = {
        station_id_from: station_id_from,
        station_id_till: station_id_to,
        date_dep: date_dep,
        time_dep: time_dep,
      }

      resp = request(path, payload)
      data = parse_response(resp)

      data['value']
    end

    # Form data:
    #   station_id_from: 2218300
    #   station_id_till: 2218000
    #   train: 111О
    #   coach_type: Л
    #   model: 0
    #   date_dep: 1466416620
    #   round_trip: 0
    #   another_ec: 0
    #
    # Example request:
    #   UZ::API#search_coaches('2218300', '2218000', '238Ш', 'П', '1466465400')
    #
    # Returns something like above:
    #   {
    #     "coach_type_id"=>4,
    #     "coaches"=>[
    #       {
    #         "num"=>1,
    #         "type"=>"П",
    #         "allow_bonus"=>false,
    #         "places_cnt"=>52,
    #         "has_bedding"=>true,
    #         "reserve_price"=>1700,
    #         "services"=>["Ч", "Ш"],
    #         "prices"=>{"Б"=>7898},
    #         "coach_type_id"=>4,
    #         "coach_class"=>"Д"
    #       },
    #       {
    #         "num"=>2,
    #         "type"=>"П",
    #         "allow_bonus"=>false,
    #         "places_cnt"=>52,
    #         "has_bedding"=>true,
    #         "reserve_price"=>1700,
    #         "services"=>["Ч", "Ш"],
    #         "prices"=>{"Б"=>7898},
    #         "coach_type_id"=>4,
    #         "coach_class"=>"Д"
    #       }
    #     ],
    #     "places_allowed"=>8,
    #     "places_max"=>8
    #   }
    #
    #
    def search_coaches(station_id_from, station_id_to, train, coach_type, date_dep)
      # timestamp = date_dep.to_time_to_i
      path = "/purchase/coaches/"
      payload = {
        station_id_from: station_id_from,
        station_id_till: station_id_to,
        train: train,
        coach_type: coach_type,
        model: 0,
        date_dep: date_dep,
      }

      resp = request(path, payload)
      data = parse_response(resp)

      data.delete('content')
      data
    end


    # Show available places in a coach.
    #
    # Form data:
    #   station_id_from: 2218300
    #   station_id_till: 2218000
    #   train: 049К
    #   coach_num: 12
    #   coach_class: Б
    #   coach_type_id: 4
    #   date_dep: 1466466300
    #   change_scheme: 0
    #
    # Example request:
    #   UZ::API#show_coach('2218300', '2218000', '136Ш', '16', 'Б', 4, '1466465400')
    #
    # Returns:
    #   {"places"=>{"Б"=>["34", "36"]}}
    #
    def show_coach(station_id_from, station_id_to, train, coach_num, coach_class, coach_type_id, date_dep)
      path = "/purchase/coach/"
      payload = {
        station_id_from: station_id_from,
        station_id_till: station_id_to,
        train: train,
        coach_num: coach_num,
        coach_class: coach_class,
        coach_type_id: coach_type_id,
        date_dep: date_dep,
      }

      resp = request(path, payload)
      data = parse_response(resp)

      data['value']
    end

    # Form data
    #   station_id_from: 2218300
    #   station_id_till: 2218000
    #   train: 238Ш
    #   date_dep: 1466443380
    def train_route(station_id_from, station_id_till, train, date_dep)
      path = "/purchase/train_route/"
      payload = {
        station_id_from: station_id_from,
        station_id_till: station_id_till,
        train: train,
        date_dep: date_dep,
      }

      resp = request(path, payload)
      data = parse_response(resp)

      # TODO parse html table as json
      data['value']
    end

    # Form data
    #   code_station_from: 2218300
    #   code_station_to: 2218000
    #   train: 049К
    #   date: 1466466300
    #   round_trip: 0
    #   places[0][ord]: 0
    #   places[0][coach_num]: 12
    #   places[0][coach_class]: Б
    #   places[0][coach_type_id]: 4
    #   places[0][place_num]: 50
    #   places[0][firstname]: FirstName
    #   places[0][lastname]: LastName
    #   places[0][bedding]: 0
    #   places[0][child]:
    #   places[0][stud]:
    #   places[0][transp]: 0
    #   places[0][reserve]: 0
    #
    def cart_add
      path = "/cart/add/"
      not_implemented
    end

    # Form data
    #   reserve_ids:354115302
    #
    def cart_revocation
      path = "/cart/revocation/"
      not_implemented
    end

    private

    # make POST request to the API
    def request(path, payload ={})
      tries = 3
      begin
        response = @agent.post(@api_url + path, payload)
      rescue Mechanize::ResponseCodeError => e
        tries -= 1
        if tries > 0
          refresh_token
          retry
        else
          raise UZ::TokenError, "Error: unhandled response."
        end
      end
    end

    def parse_response(resp)
      data = JSON.load resp.body
      if data['error']
        raise UZ::APIError, "Error: #{data['value']}"
      end

      return data
    end

    def not_implemented
      logger = Logger.new(STDOUT)
      logger.warn('Method not yet implemented')
    end
  end
end
