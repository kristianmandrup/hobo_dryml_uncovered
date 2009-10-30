module LoggingMethodRules
  def get_method_name(msg)
    cls_name = class_name(msg)
    meth_name_x = msg.sub(/(.*?#{cls_name})(::|\.)(.*?)/, '\3')
    meth_name_x.sub(/(\w+)(.*)/, '\1')    
  end

  def method_begin?(msg)
    'begin' if msg.include?('BEGIN')
  end

  def method_end?(msg)
    'end' if msg.include?('END')
  end

  def method_pos(msg)
    method_begin?(msg) || method_end?(msg)
  end

  def handle_method(meth_name, meth_pos)        
    if meth_pos == 'begin'
      @log_method_stack.push(meth_name)
    elsif meth_pos == 'end'
      @log_method_stack.pop
    end      
  end

  def log_method?(msg)
    handle_method(get_method_name(msg), method_pos(msg))    
    cls_name = class_name(msg)
    return false if !cls_name || cls_name.blank?     

    # @log.debug "Class name:" + cls_name
    dryml_methods = @log_dryml_methods[cls_name.to_sym] || {}  
    current_meth = @log_method_stack.last
    if current_meth && dryml_methods
      return false if log_exclude?(current_meth, dryml_methods)
      return true if log_include?(current_meth, dryml_methods)
    end
    return dryml_methods[:default] || true
  end
end