module TraceExt
  def indentation
    s = ""
    lv = method_stack.empty? ? 0 : method_stack.size-1 
    lv.times { s << "  " }
    s
  end

  def method_full_name(context)
    "#{context[:class_name]}.#{context[:method_name]}"
  end


  def method_stack
    @method_stack ||= []
  end


  def handle_before_call(context)
    lines = []
    lines << "==============================================="                      
    lines << "==> #{context[:method_full_name]} : BEGIN"
    lines << "-----------------------------------------------"
    lines << "#{context[:args].inspect}"
    lines << "-----------------------------------------------"                      
  if context[:block]       
    lines << "(and a block)"
    lines << "-----------------------------------------------"                
  end
    output(lines, context)
  end

  def handle_after_call(context)
    lines = []
    lines << "<<= #{context[:method_full_name]} : END"
    lines << "-----------------------------------------------"         
    lines << "#{context[:result]}"
    lines << "==============================================="  
    output(lines, context)              
  end

  def output(lines, context)
    spaces = indentation
    lines.map!{|line| spaces + line + "\n"}
    output_handler(lines, context)
  end
  
  # default output action: put string to STDOUT
  # override this to customize trace handling
  def output_handler(lines, context)
    puts lines.join
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