class Cargo_train < Train

  attr_accessor :type
  def initialize(number)
    super(number, 'Cargo')
  end
end