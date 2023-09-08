# frozen_string_literal: true

module Manufacturer
  attr_accessor :manufacturer
end

module InstanceCounter
  def self.included(base)
    base.extend(ClassMethods)
    base.send :include, InstanceMethods
  end

  module ClassMethods
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

  module Validity
    def valid?
      validate!
      true
    rescue StandardError
      false
    end
  end
end
