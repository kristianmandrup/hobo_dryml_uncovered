module Hobo::Dryml
  class Template
    include TraceCalls
    include SaveErb
  end
  
  class TemplateEnvironment
    include TraceCalls
  end
  
  class Taglib
    include TraceCalls
    
    class << self
      include TraceUtils
    end
  end
  
  class DRYMLBuilder
    include TraceCalls
    include SaveEnv
  end


  class TemplateHandler < ActionView::TemplateHandler
    include TraceCalls
  end
end

module ActionController
  class Base
    include TraceCalls
  end
end

class ActionView::Template
  include TraceCalls
end





