require_relative 'modules'

class Cart
  attr_accessor :type
  include Manufacturer
end