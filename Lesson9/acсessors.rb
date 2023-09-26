# frozen_string_literal: true

module Accessors
  def attr_accesor_with_history(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym
      history_var = "@#{name}_history".to_sym
      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}=") do |value|
        if instance_variable_get(history_var).nil?
          instance_variable_set(history_var, [])
        else
          instance_variable_get(history_var) << instance_variable_get(var_name)
        end
        instance_variable_set(var_name, value)
      end
    end
  end

  def strong_attr_accesor(name, class_name)
    var_name = "@#{name}".to_sym
    define_method(name) { instance_variable_get(var_name) }
    define_method("#{name}=") do |value|
      raise "Error, value (#{value}) class is not #{class_name}" if value.class != class_name

      instance_variable_set(var_name, value)
    end
  end
end
