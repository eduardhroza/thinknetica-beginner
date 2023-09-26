# frozen_string_literal: true

class CargoTrain < Train
  def initialize(number)
    @type = :cargo
    super
  end
end
