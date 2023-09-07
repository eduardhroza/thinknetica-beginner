class CartCargo < Cart
  
  NUMBER_FORMAT = /\A(?:6[4-9]|[7-9]\d|1\d{2}|250)\z/

  def initialize(total_volume)
    @type = :cargo
    @total_volume = total_volume.to_s
    @occupied_volume = 0
    @@current_number += 1
    @number += @@current_number
    super()
  end

  def bulk(volume) # Load the cart.
    volume = volume.to_i 
    if (occupied_volume + volume) > @total_volume.to_i
      puts "Volume exceeds available space."
    else
      @occupied_volume += volume
      @total_volume = (@total_volume.to_i - volume)
    end
  end
  
  def occupied_volume
    @occupied_volume
  end

  def free_volume
    @total_volume.to_i - occupied_volume.to_i
  end

  def validate!
    errors = []
    errors << "Volume can't be empty." if @total_volume.nil? || @total_volume == ""
    errors << "Invalid volume. Must be a number from 64 to 250 m3." unless @total_volume.to_s =~ NUMBER_FORMAT
    raise errors.join(".") unless errors.empty?
  end
  
end