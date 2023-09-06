require_relative 'modules'

class Cart
  attr_accessor :type
  attr_reader :seats, :used_seats
  include Manufacturer
  NUMBER_FORMAT = /\A([1-9]|1\d|25)\z/

  def initialize(seats)
    @seats = seats.to_s
    validate!
    @used_seats = 0
  end

  def validate!
    errors = []
    errors << "Number of seats can't be empty." if @seats.nil? || @seats == ""
    errors << "Invalid number of seats. Must be a number from 1 to 25." unless @seats =~ NUMBER_FORMAT
    raise errors.join(".") unless errors.empty?
  end

  def used_seats
    @used_seats
  end

  def free_seats
    @seats - @used_seats
  end
end