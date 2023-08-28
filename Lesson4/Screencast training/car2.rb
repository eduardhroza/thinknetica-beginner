# Класс со скринкаста

class Car
attr_reader :current_rpm

def initialize
  @current_rpm = 0
end

def start_engine
  start_engine! if engine_stopped?
end

def engine_stopped?
  # true, if rpm == 0
  current_rpm.zero?
end

protected
attr_writer :current_rpm

def initial_rpm
  700
end

def start_engine!
  self.current_rpm = initial_rpm
end

end

class Truck < Car
  def load
  end

  protected

  def initial_rpm
    500
  end

end

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