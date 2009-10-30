require 'trace_calls.rb'

module Hobo
  module Dryml
    class Taglib
      include TraceCalls
      
      def initialize
        @a = "a"
        @b = 4
      end
      
      def do_a(a)        
        @a + a + "b"
      end

      def do_b(b)        
        @b + b + 1
      end
      
    end
  end
end

x = Hobo::Dryml::Taglib.new
x.do_a("x")
x.do_b(3)

