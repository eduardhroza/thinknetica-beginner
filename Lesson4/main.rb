require_relative 'route'
require_relative 'station'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'cart'
require_relative 'cart_passenger'
require_relative 'cart_cargo'

$user_trains = [] #Поезда
$user_routes_storage = [] #Маршруты
$user_stations = [] #Станции
$user_carts = [] #Вагоны

# В моём коде вагоны (Wagons) я прописываю как "Cart/carts (вагонетки), так как вагон технически не бывает грузовым, это грузовая вагонетка."


def menu
    puts "Please select and action by number:
    1  -  Station & Route management.
    2  -  Create a train.
    3  -  Wagons management
    4  -  Assign route for a train
    5  -  Move train
    6  -  Show all stations and list of trains on the stations.
    7  -  Exit"
end

def station_and_route_management

    loop do
        puts "Please select an action by number: 
        1  -  Create route. 
        2  -  Create station. 
        3  -  Operate routes.
        4  -  Return to the main menu.
        5  -  Exit."
          
        sub_menu_selection = gets.chomp.to_i
      
        if sub_menu_selection == 1 # Create route.
          puts "Please assign departure station:"
          first_station = Station.new(gets.chomp)
          $user_stations << first_station
          puts "Please assign final station:"
          last_station = Station.new(gets.chomp)
          $user_stations << last_station
          user_routes = Route.new(first_station, last_station)
          $user_routes_storage << user_routes
          puts "Route #{user_routes.stations.map(&:name).join(' -> ')} has been added."

        elsif sub_menu_selection == 2 # Create station.
          puts "Please enter the name of your station:"
          $user_stations << Station.new(gets.chomp)
          puts "Station #{$user_stations.last.name} has been added."

        elsif sub_menu_selection == 3 # Operate routes.
            if $user_routes_storage.empty?
                puts "No routes available"
                station_and_route_management
            else
                puts "Please select a route:"
                $user_routes_storage.each_with_index do |route, index|
                  station_names = route.stations.map(&:name).join(' -> ') # Чтоб на экран выводились имена станций.
                  puts "#{index + 1} - #{station_names}"
                end
            end

            route_selection = gets.chomp.to_i
            if route_selection > 0 && route_selection <= $user_routes_storage.size
                selected_route = $user_routes_storage[route_selection -1]

                puts "Selected route: #{selected_route.stations.map(&:name).join(' -> ')}"
            
                puts "Please select the required action:
                1  -  Add station.
                2  -  Remove station.
                3  -  Return."
                sub_menu_selection = gets.chomp.to_i
            else 
                puts "Invalid selection."
                break
            end
            
            if sub_menu_selection == 1
                puts "Enter the intermediate station:"
                additional_station = Station.new(gets.chomp)
                $user_stations << additional_station
                selected_route.add_intermediate_station(additional_station)
                puts "Intermediate station #{additional_station.name} has been added to the route."
            
            elsif sub_menu_selection == 2
                puts "Enter the station name to remove:"
                remove_station = gets.chomp
                if $user_stations.include?(remove_station)
                    selected_route.remove_intermediate_station(remove_station)
                    puts "Station #{remove_station}has been removed from the route."
                else puts "#{remove_station} station is missing in the route."
                    station_and_route_management
                end
            elsif sub_menu_selection == 3
                sub_menu_selection
            else
                puts "Error: Invalid selection."
        end

        elsif sub_menu_selection == 4 #Return to the main menu.
          break 

        elsif sub_menu_selection == 5 #Exit.
          exit
        else
          puts "Error: Invalid selection."
          exit
        end
    end
end

def create_train
    puts "Please enter the train number:"
    number = gets.chomp
    puts "Please select the type of train:
    1  -  Passenger train
    2  -  Cargo train"
    user_selection = gets.chomp.to_i

    if user_selection == 1
    train = Passenger_train.new(number)
    puts "Passenger train with number #{number} was created"
    $user_trains << train

    elsif user_selection == 2
        train = Cargo_train.new(number)
        puts "Cargo train with number #{number} was created"
        $user_trains << train

    else puts "Invalide selection"
        create_train
    end
end

def wagon_management 
    puts "Please select the train for wagon management:"

    unless $user_trains.empty?
        $user_trains.each_with_index do |train, index|
            puts "#{index + 1}  -  Train No.#{train.number} / type: #{train.type}"
        end
        
        user_selection = gets.chomp.to_i

        if user_selection >= 1 && user_selection <= $user_trains.size
            selected_train = $user_trains[user_selection - 1]

            puts "Selected train: #{selected_train.number}"

            puts "Please select an option to operate:

            1  -  Create wagon
            2  -  Attach wagon
            3  -  Detach wagon"
            
            user_selection = gets.chomp.to_i
            
            if user_selection == 2
                if selected_train.type == 'Passenger'
                    cart = Cart_passenger.new
                    selected_train.attach_cart(cart)
                elsif selected_train.type == 'Cargo'
                    cart = Cart_cargo.new
                    selected_train.attach_cart(cart)
                else
                    puts "Invalid train type."
                    wagon_management
                end

            elsif user_selection == 3
                cart = selected_train.carts.size - 1
                if cart >= 0
                    selected_train.detach_cart(selected_train.carts[cart])
                    puts "Last wagon detached."
                    $user_carts << cart
                else puts "No wagons to detach."
                end

            elsif user_selection == 1
                puts "Please specify the type of wagon:
                1  -  Passenger wagon
                2  -  Cargo cart"
                user_selection = gets.chomp.to_i
                if user_selection == 1
                    wagon = Cart_passenger.new
                    $user_carts << wagon
                    puts "Passenger wagon has been created."
                elsif user_selection == 2
                    wagon = Cart_cargo.new
                    $user_carts << wagon
                    puts "Cargo cart has been created."
                end
            end

        else
            puts "Invalid selection."
        end
    else
        puts "No trains available to manage."
    end
end

def assign_route 
    if $user_routes_storage.empty?
        puts "No routes available. Please create a route first (Go to the main menu -> Station & Route management - > Create route)."
    else
        puts "Please select a route from the list:"
        $user_routes_storage.each_with_index do |route, index|
            station_names = route.stations.map(&:name).join(' -> ')
            puts "#{index + 1}  -  Route #{station_names}"
          end
        route_selection = gets.chomp.to_i
        
        if route_selection >= 1 && route_selection <= $user_routes_storage.size
            selected_route = $user_routes_storage[route_selection - 1]

            puts "Please assign a train for the route #{selected_route}."
            if $user_trains.empty?
                puts "No trains available."
                menu
            else
                $user_trains.each_with_index do |train, index|
                    puts "#{index + 1}  -  Train No.#{train.number} / type: #{train.type}"
                end
            end
            
            train_selection = gets.chomp.to_i
    
            if train_selection >= 1 && train_selection <= $user_trains.size
                selected_train = $user_trains[train_selection - 1]
                selected_train.assign_route(selected_route)
                puts "Route #{selected_route.stations.map(&:name).join(' -> ')} assigned for the train No.#{selected_train.number}"
            else
                puts "Wrong selection."
                assign_route
            end

        else
            puts "Wrong selection."
            assign_route
        end
    end
end

def move_train
    if $user_trains.empty?
        puts "No trains available."

    else puts "Please select the train to operate:"
        $user_trains.each_with_index do |train, index|
            puts "#{index + 1}  -  Train No.#{train.number} / type: #{train.type}"
        end   
        user_selection = gets.chomp.to_i
        if user_selection >= 1 && user_selection <= $user_trains.size
            selected_train = $user_trains[user_selection - 1]
            puts "Selected train: #{selected_train.number}"

            puts "Please select an option:
            1  -  Move to the next station
            2  -  Move to the previous station
            3  - Return"
            user_selection = gets.chomp.to_i

            if user_selection == 1
                selected_train.move_forward
                puts "Train #{selected_train.number} has arrived to #{selected_train.current_station.name} station."
            elsif user_selection == 2
                selected_train.move_backward
                puts "Train #{selected_train.number} has arrived to #{selected_train.current_station.name} station."
            elsif user_selection == 3
                menu
            else puts "Wrong selection."
                menu
            end
        end
    end
end

def show_all
    if $user_stations.empty? && $user_trains.empty?
        puts "No stations and trains available."
        menu
    elsif $user_stations.empty? && !$user_trains.empty?
        puts "No stations available, trains are at the depot."
    else
        $user_stations.each do |station|
            puts "Station: #{station.name}"
            if station.trains.empty?
                puts "  No trains at the station."
            else
                puts "  Trains:"
                station.trains.each do |train|
                    puts "Type: #{train.type}, Number: #{train.number}"
                end
          end
        end
    end
end

loop do
    menu
    user_selection = gets.chomp.to_i
    break if user_selection == 7
  
    if user_selection == 1
        station_and_route_management
    end

    if user_selection == 2
        create_train
    end

    if user_selection == 3
        wagon_management
    end

    if user_selection == 4
        assign_route
    end

    if user_selection == 5
        move_train
    end

    if user_selection == 6
        show_all
    end
end