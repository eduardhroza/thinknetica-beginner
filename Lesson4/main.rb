require_relative 'route'
require_relative 'station'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'cart'
require_relative 'cart_passenger'
require_relative 'cart_cargo'

# В моём коде вагоны (Wagons) я прописываю как "Cart/carts (вагонетки), так как вагон технически не бывает грузовым, это грузовая вагонетка."

class Main

    def initialize
        @trains = [] #Поезда
        @routes_storage = [] #Маршруты
        @stations = [] #Станции
        @carts = [] #Вагоны
    end

    def start
        loop do
          show_menu
          choice = get_user_choice
          action(choice)
        end
    end

    def show_menu
        puts "Please select an action by number:"
        puts "1  -  Station & Route management."
        puts "2  -  Create a train."
        puts "3  -  Wagons management."
        puts "4  -  Assign route for a train."
        puts "5  -  Move train."
        puts "6  -  Show all stations and list of trains on the stations."
        puts "7  -  Exit."
    end

    def get_user_choice
        gets.chomp
    end

    def action(choice)
        case choice
        when '1'
          station_and_route_management
        when '2'
          create_train
        when '3'
          wagon_management
        when '4'
          assign_route
        when '5'
          move_train
        when '6'
          show_all
        when '7'
          exit
        else
          puts "Invalid choice. Please try again."
        end
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
              @stations << first_station
              puts "Please assign final station:"
              last_station = Station.new(gets.chomp)
              @stations << last_station
              user_routes = Route.new(first_station, last_station)
              @routes_storage << user_routes
              puts "Route #{user_routes.stations.map(&:name).join(' -> ')} has been added."
    
            elsif sub_menu_selection == 2 # Create station.
              puts "Please enter the name of your station:"
              @stations << Station.new(gets.chomp)
              puts "Station #{@stations.last.name} has been added."
    
            elsif sub_menu_selection == 3 # Operate routes.
                if @routes_storage.empty?
                    puts "No routes available"
                    station_and_route_management
                else
                    puts "Please select a route:"
                    @routes_storage.each_with_index do |route, index|
                      station_names = route.stations.map(&:name).join(' -> ') # Чтоб на экран выводились имена станций.
                      puts "#{index + 1} - #{station_names}"
                    end
                end
    
                route_selection = gets.chomp.to_i
                if route_selection > 0 && route_selection <= @routes_storage.size
                    selected_route = @routes_storage[route_selection -1]
    
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
                    @stations << additional_station
                    selected_route.add_intermediate_station(additional_station)
                    puts "Intermediate station #{additional_station.name} has been added to the route."
                
                elsif sub_menu_selection == 2
                    puts "Enter the station name to remove:"
                    remove_station = gets.chomp
                    if @stations.any? { |station| station.name == remove_station }
                      selected_route.remove_intermediate_station(remove_station)
                      puts "Station #{remove_station} has been removed from the route."
                      @stations.delete(remove_station)
                    else
                      puts "#{remove_station} station is missing in the route."
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
        train = PassengerTrain.new(number)
        puts "Passenger train with number #{number} was created"
        @trains << train
    
        elsif user_selection == 2
            train = CargoTrain.new(number)
            puts "Cargo train with number #{number} was created"
            @trains << train
    
        else puts "Invalide selection"
            create_train
        end
    end
    
    def wagon_management 
        puts "Please select the train for wagon management:"
    
        unless @trains.empty?
            @trains.each_with_index do |train, index|
                puts "#{index + 1}  -  Train No.#{train.number} / type: #{train.type}"
            end
            
            user_selection = gets.chomp.to_i
    
            if user_selection >= 1 && user_selection <= @trains.size
                selected_train = @trains[user_selection - 1]
    
                puts "Selected train: #{selected_train.number}"
    
                puts "Please select an option to operate:
    
                1  -  Create wagon
                2  -  Attach wagon
                3  -  Detach wagon"
                
                user_selection = gets.chomp.to_i
                
                if user_selection == 2
                    if selected_train.type == 'Passenger'
                        cart = CartPassenger.new
                        selected_train.attach_cart(cart)
                    elsif selected_train.type == 'Cargo'
                        cart = CartCargo.new
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
                        @carts << cart
                    else puts "No wagons to detach."
                    end
    
                elsif user_selection == 1
                    puts "Please specify the type of wagon:
                    1  -  Passenger wagon
                    2  -  Cargo cart"
                    user_selection = gets.chomp.to_i
                    if user_selection == 1
                        wagon = CartPassenger.new
                        @carts << wagon
                        puts "Passenger wagon has been created."
                    elsif user_selection == 2
                        wagon = CartCargo.new
                        @carts << wagon
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
        if @routes_storage.empty?
            puts "No routes available. Please create a route first (Go to the main menu -> Station & Route management -> Create route)."
        else
            puts "Please select a route from the list:"
            @routes_storage.each_with_index do |route, index|
                station_names = route.stations.map(&:name).join(' -> ')
                puts "#{index + 1}  -  Route #{station_names}"
              end
            route_selection = gets.chomp.to_i
            
            if route_selection >= 1 && route_selection <= @routes_storage.size
                selected_route = @routes_storage[route_selection - 1]
    
                puts "Please assign a train for the route #{selected_route}."
                if @trains.empty?
                    puts "No trains available."
                    show_menu
                else
                    @trains.each_with_index do |train, index|
                        puts "#{index + 1}  -  Train No.#{train.number} / type: #{train.type}"
                    end
                end
                
                train_selection = gets.chomp.to_i
        
                if train_selection >= 1 && train_selection <= @trains.size
                    selected_train = @trains[train_selection - 1]
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
        if @trains.empty?
            puts "No trains available."
    
        else puts "Please select the train to operate:"
            @trains.each_with_index do |train, index|
                puts "#{index + 1}  -  Train No.#{train.number} / type: #{train.type}"
            end   
            user_selection = gets.chomp.to_i
            if user_selection >= 1 && user_selection <= @trains.size
                selected_train = @trains[user_selection - 1]
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
                    show_menu
                else puts "Wrong selection."
                    show_menu
                end
            end
        end
    end
    
    def show_all
        if @stations.empty? && @trains.empty?
            puts "No stations and trains available."
            show_menu
        elsif @stations.empty? && !@trains.empty?
            puts "No stations available, trains are at the depot."
        else
            @stations.each do |station|
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
end

Main.new.start