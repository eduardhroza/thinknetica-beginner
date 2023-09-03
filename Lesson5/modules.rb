module Manufacturer
  attr_accessor :manufacturer

  def set_manufacturer(name)
    self.manufacturer = name
  end

  def get_manufacturer
    manufacturer
  end
end

module InstanceCounter
  def self.included(base)
    base.extend(ClassMethods)
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_accessor :instances

    def instances
      @instances ||= 0
    end
  end

  module InstanceMethods
    private

    def register_instance
      self.class.instances += 1
    end
  end
end