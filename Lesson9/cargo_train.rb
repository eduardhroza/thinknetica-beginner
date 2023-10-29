# frozen_string_literal: true

class CargoTrain < Train
  validate :number, :format, NUMBER_FORMAT
  validate :number, :type, String
  def initialize(number)
    @type = :cargo
    super
  end
end
