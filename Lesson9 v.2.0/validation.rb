# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    attr_accessor :validations

    def validate(number, type, *args)
      @validations ||= []
      @validations << { number: number, type: type, args: args }
    end
  end

  module InstanceMethods
    def validate!
      self.class.validations.each do |val|
        attr = instance_variable_get("@#{val[:number]}".to_sym)
        send("#{val[:type]}_validate", attr, val[:args])
      end
    end

    def presence_validate(attr, _)
      raise 'An attribute cannot be empty!' if attr == '' || attr.nil?
    end

    def format_validate(attr, arg)
      raise 'The attribute must match the format!' if attr !~ arg[0]
    end

    def type_validate(attr, arg)
      raise "The type does not correspond to the specified class! #{attr.class} #{arg}" if arg != [attr.class]
    end

    def valid?
      validate!
      true
    rescue StandardError
      false
    end
  end
end
