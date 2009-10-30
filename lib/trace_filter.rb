class String
  def in_module?(module_name)
    modules = self.split("::")[0..-2]
    modules.include?(module_name)      
  end
end  


module Tracing
    
  def register_filter(_filter)
    if _filter.kind_of?(Array)
      @filters + _filter
    else
      @filters << _filter
    end
  end

  def unregister_filter(_filter)
    @filters.delete(_filter)
  end
  
  def apply_filters(txt)
    @filters ||= []    
    @filters.each do |_filter|
      # apply filter
      txt = _filter.execute(txt) if !txt.blank?
    end
  end

  class Filter
    def execute(txt, context)
    end
  end
end

module Tracing
  class MethodFilter
    def initialize(options)
    end

    def execute(txt, context)
      method_name = context[:method_name]
      txt if !method_name == 'one'
    end
  end
end

module Tracing
  class DrymlTemplateFilter
    def initialize(options)
    end
    
    def execute(txt, context)
      class_name = context[:class_name]    
      txt if !class_name == 'My::Example'
    end
  end
end

class Array
  def matches_any?(rule)
    self.any? do |rule| 
      rule =~ class_name if rule.kind_of? Regexp
      rule == class_name if rule.kind_of? String
      raise Exception "bad argument!"
    end
  end
  
  def rules_allow?(name)
    return true if self[:include].matches_any?(class_name)
    return false if self[:exclude].matches_any?(class_name)
    return self[:default]
  end 
end

module Tracing
  class ClassFilter
    def initialize(options)
      @class_rules = options[:class_rules] || {}      
    end

    def execute(txt, context)
      class_name = context[:class_name]
      @class_rules[:modules].each do |_module|
        module_name = _module[:name]    
        if class_name.in_module?(module_name)
          class_rules = _module[:class_rules]  
          return if !class_rules.rules_allow?(class_name)
        end
      end
      # log it!
    end
  end
end

module TraceExt  
  include Tracing

  def configure 
    @filters = []
  end
  
  def output_handler(txt)
    puts apply_filters(txt)
  end
end

module TraceExt

  def dryml_classes
    {:modules => [
      {:name 'Hobo:Dryml', 
        :class_rules => {
          :include => [/Template.*/, 'DRYMLBuilder'], 
          :exclude => ['Taglib'], 
          :default => true  
        }
      }]
    }      
  end
  
  def dryml_class_filter
    class_filter_options = {:class_rules => dryml_classes}
    Tracing::ClassFilter.new(class_filter_options)
  end
  
  def dryml_filters
    # method_filter = Tracing::MethodFilter.new(dryml_methods)
    class_filter = dryml_class_filter
    
    # dryml_template_filter = Tracing::DrymlTemplateFilter.new    
    [] << class_filter # << method_filter << dryml_template_filter
  end
    
  def configure 
    filters = dryml_filters
  end
end
