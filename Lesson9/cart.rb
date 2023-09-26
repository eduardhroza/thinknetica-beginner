# rubocop:disable Style/ClassVars
# frozen_string_literal: true

class Cart
  attr_accessor :type, :number
  attr_reader :total_place, :used_place

  include Manufacturer
  @@number = 0
  NUMBER_FORMAT_CARGO = /\A(?:6[4-9]|[7-9]\d|1\d{2}|250)\z/.freeze
  NUMBER_FORMAT_PASSENGER = /^(?:[1-9]|1\d|2[0-5])$/.freeze

  def initialize(total_place)
    @total_place = total_place
    @used_place = 0
    @number = @@number += 1
  end

  def free_place
    @free_place = @total_place - @used_place
  end

  def validate!
    errors = []
    if type == :cargo
      errors << 'Invalid volume. Must be a number from 64 to 250 m3.' unless @total_place.to_s =~ NUMBER_FORMAT_CARGO
    else
      type
      unless @total_place.to_s =~ NUMBER_FORMAT_PASSENGER
        errors << 'Invalid number of seats. Must be a number from 1 to 25.'
      end
    end
    raise errors.join('.') unless errors.empty?
  end
end

# rubocop:enable Style/ClassVars
