# frozen_string_literal: true

class PassengerTrain < Train
  validate :number, :format, NUMBER_FORMAT
  validate :number, :type, String
  def initialize(number)
    @type = :passenger
    super
  end
end
