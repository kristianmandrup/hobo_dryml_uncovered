module LoggingClassRules
  
  def setup_class_and_method_rules
    # fine tuning by dryml class
    @log_dryml_classes = {:includes => ['TemplateEnvironment'], :excludes => ['Taglib'], :default => true} 

    # TODO
    @log_dryml_methods = {
      :TemplateEnvironment => {
        :includes => ['call_tag_parameter_with_default_content'], 
        :excludes => ['call_tag_parameter'] 
      }, 
      :Template => {
        :includes => [], 
        :excludes => [] 
      } 
    }   
  end
  
  def dryml_class?(msg)
    msg.include?('Hobo::Dryml')
  end

  def class_name(msg)
    return 'Taglib' if msg.include?('Taglib')
    return 'DRYMLBuilder' if msg.include?('DRYMLBuilder')
    return 'TemplateEnvironment' if msg.include?('TemplateEnvironment')
    return 'Template' if msg.include?('Template')
  end
  
  def log_class?(msg)
    if dryml_class?(msg)
      cls_name = class_name(msg)
      return false if log_exclude?(cls_name, @log_dryml_classes)
      return true if  log_include?(cls_name, @log_dryml_classes)
    end
    return @log_dryml_classes[:default] || true
  end
  
end