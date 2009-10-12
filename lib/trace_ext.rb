module TraceExt
  def indentation
    s = ""
    lv = method_stack.empty? ? 0 : method_stack.size-1 
    lv.times { s << "  " }
    s
  end

  def method_stack
    @method_stack ||= []
  end

  def output(txt)
    puts indentation << txt
  end
  
  def included_simple?(methods, name)
    methods.include?(name) 
  end

  def included_by_regexp?(methods, name)
    methods.any? do |m| 
      if m.is_a? Regexp
        name =~ /#{m}/
      else
        name == m
      end
    end
  end

  def included?(methods, name)
    return included_by_regexp?(methods, name) if use_reg_exp_match?
    included_simple?(methods, name)
  end
  
  def exclude?(name)
    return true if included?(exclude_methods, name)
  end

  def include?(name)
    return true if included?(include_methods, name)
  end

  def trace_method?(name)        
    return false if exclude?(name)
    return true if include?(name)
    return method_trace?
  end    
  
  def exclude_methods
    []
  end

  def include_methods 
    []
  end

  # true to trace any method by default
  def method_trace? 
    true
  end    

  def use_reg_exp_match? 
    true
  end    
end