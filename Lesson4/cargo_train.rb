class CargoTrain < Train

  attr_accessor :type
  def initialize(number)
    super(number, 'Cargo')
  end
end