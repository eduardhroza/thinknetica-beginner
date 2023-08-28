class SportCar < Car
  protected

  def start_engine
    puts "Click!"
    super
    puts "Wroom!"
  end
  
  def initial_rpm
    1000
  end
end