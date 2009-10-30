require 'trace_calls'
require 'trace_log'
# require 'logging'
# require 'trace_filter'

module My
  class Example
    include TraceCalls

    def one(arg)
      two(arg, 5)
    end

    def two(arg1, arg2)
      three(arg1, arg2, 5)
    end

    def three(arg1, arg2, arg3)
      arg1 + arg2 + arg3
    end
    
  end
end

module LoggingRules
  def self.class_method_rules 
    {'My::Example' => {
      :include => ['one'], 
      :exclude => [/thr*/, 'two'], 
      :default => true}
    }
  end
  
  def self.method_rules(class_name)
    class_method_rules[class_name.to_s]      
  end
end

My::Example.class_eval do

  def exclude_methods
    rules = LoggingRules.method_rules(self.class)
    rules[:exclude]
  end
  
  def include_methods 
    rules = LoggingRules.method_rules(self.class)
    rules[:include]
  end
  
end  


ex1 = My::Example.new

puts ex1.one(7)
puts ex1.two(4, 5) 
puts ex1.three(4, 7, 3) 

