# frozen_string_literal: true

class Menu
  def show_menu
    puts 'Please select an action by number:'
    puts '1  -  Station & Route management.'
    puts '2  -  Create a train.'
    puts '3  -  Train wagon management.'
    puts '4  -  Assign route for a train.'
    puts '5  -  Move train.'
    puts '6  -  Show all stations and list of trains on the stations.'
    puts '7  -  Exit.'
  end

  def wagon_menu
    puts 'Please select an option to operate:'
    puts '1  -  Create wagon'
    puts '2  -  Attach wagon'
    puts '3  -  Detach wagon'
    puts '4  -  Display wagons'
  end

  def create_wagon_menu
    puts 'Please specify the type of wagon:'
    puts '1  -  Passenger wagon'
    puts '2  -  Cargo cart'
  end

  def operate_route_menu
    puts 'Please select the required action:'
    puts '1  -  Add station.'
    puts '2  -  Remove station.'
    puts '3  -  Return.'
  end

  def move_train_menu
    puts 'Please select an option:'
    puts '1  -  Move to the next station'
    puts '2  -  Move to the previous station'
    puts '3  - Return'
  end

  def route_menu
    puts 'Please select an action by number:'
    puts '1  -  Create route.'
    puts '2  -  Create station.'
    puts '3  -  Operate routes.'
    puts '4  -  Return to the main menu.'
  end

  def create_train_menu
    puts 'Please select the type of train:'
    puts '1  -  Passenger train'
    puts '2  -  Cargo train'
  end
end
