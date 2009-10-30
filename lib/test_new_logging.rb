require 'logging'

module Hobo
  module Dryml
    class Taglib
      include Logging
      
      def hello(options)
        puts "hello"
      end
    end
  end
end