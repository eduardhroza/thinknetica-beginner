# frozen_string_literal: true

class CartCargo < Cart
  def initialize(total_volume)
    @type = :cargo
    super
  end

  def fill_volume(volume)
    @used_place += volume if free_place >= 0
    free_place
  end
end
