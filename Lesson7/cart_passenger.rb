class CartPassenger < Cart

  def initialize(total_seats)
    @type = :passenger
    super
  end

  def take_place
    free_place
    @used_place += 1 if @free_place > 0
  end 
  
end