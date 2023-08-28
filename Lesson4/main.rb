require_relative 'route'
require_relative 'station'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'cart'
require_relative 'cart_passenger'
require_relative 'cart_cargo'

$user_trains = []
$user_routes_storage = []
$user_stations = []
$user_carts = []

# В моём коде вагоны (Wagons) я прописываю как "Cart/carts (вагонетки), так как вагон технически не бывает грузовым, это грузовая вагонетка."

=begin
- Назначать маршрут поезду
- Перемещать поезд по маршруту вперед и назад
- Просматривать список станций и список поездов на станции
=end


def menu
    puts "Please select and action by number:
    1  -  Station & Route management.
    2  -  Create a train.
    3  -  Wagons management
    4  -  Assign route for a train
    ##############################################################
    5  -  Move train
    6  -  Show all stations and list of trains on the stations.
    9  -  Exit"
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
          first_station = gets.chomp
          puts "Please assign final station:"
          last_station = gets.chomp
          user_routes = Route.new(first_station, last_station)
          $user_routes_storage << user_routes
          puts "Route #{user_routes} has been added."

        elsif sub_menu_selection == 2 # Create station.
          puts "Please enter the name of your station:"
          $user_stations << gets.chomp
          puts "Station #{$user_stations.last} has been added."

        elsif sub_menu_selection == 3 # Operate routes.
            if $user_routes_storage.empty?
                puts "No routes available"
                break
            else
                puts "Please select a route:"
                $user_routes_storage.each_with_index do |route, index|
                    puts "#{index + 1} - #{route.stations}"
                end
            end

            route_selection = gets.chomp.to_i
            if route_selection > 0 && route_selection <= $user_routes_storage.size
                selected_route = $user_routes_storage[route_selection -1]

                puts "Selected route: #{selected_route.stations.join(' -> ')}"
            
                puts "Please select the required action:
                1  -  Add station.
                2  -  Remove station."
                sub_menu_selection = gets.chomp.to_i
            else 
                puts "Invalid."
            end
            
            if sub_menu_selection == 1
                puts "Enter the intermediate station:"
                additional_station = gets.chomp
                selected_route.add_intermediate_station(additional_station)
                puts "Intermediate station #{additional_station} has been added to the route."
            
            elsif sub_menu_selection == 2
                puts "Enter the station to remove:"
                remove_station = gets.chomp
                selected_route.remove_intermediate_station(remove_station)
                puts "Station #{remove_station}has been removed from the route."

            else
                puts "Error: Invalid operate selection."
        end

        elsif sub_menu_selection == 4 #Return to the main menu.
          break 

        elsif sub_menu_selection == 5 #Exit.
          puts "User routes: #{$user_routes_storage}"
          puts "User routes: #{$user_stations}"
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
    puts "#{$user_trains}"

    elsif user_selection == 2
        train = Cargo_train.new(number)
        puts "Cargo train with number #{number} was created"
        $user_trains << train
        puts "#{$user_trains}"

    else puts "Invalide selection"
        create_train
    end
end

def wagon_management # Доработать
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

            1  -  Attach wagon
            2  -  Detach wagon"
            
            user_selection = gets.chomp.to_i
            
            if user_selection == 1
                if selected_train.type == 'Passenger'
                    cart = Cart_passenger.new
                    $user_carts << cart
                    selected_train.attach_cart(cart)
                elsif selected_train.type == 'Cargo'
                    cart = Cart_cargo.new
                    selected_train.attach_cart(cart)
                else
                    puts "Invalid train type."
                    wagon_management
                end

            elsif user_selection == 2
                cart = selected_train.carts.size - 1
                if cart >= 0
                    selected_train.detach_cart(selected_train.carts[cart])
                    puts "Last cart detached."
                else puts "No carts to detach."
                end
            end

        else
            puts "Invalid selection."
        end
    else
        puts "No trains available to manage."
    end
end

def assign_route #не работает
    if $user_routes_storage.empty?
        puts "No routes available. Please create a route first (Go to the main menu -> Station & Route management - > Create route)."
    else
        puts "Please select a route from the list:"
        $user_routes_storage.each_with_index do |route, index|
            puts "#{index + 1}  -  Route #{route.stations.join(' -> ')}"
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
                puts "Route #{selected_route.stations.join(' -> ')} assigned for the train No.#{selected_train.number}"
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


loop do
    menu
    user_selection = gets.chomp.to_i
    break if user_selection == 9
  
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
end