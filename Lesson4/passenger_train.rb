class Passenger_train < Train
  
  attr_accessor :type
  def initialize(number)
    super(number, 'Passenger')
  end
end