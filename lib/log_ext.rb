module LogOutput
  # use to control detail lv of logging
  def log_detail(msg)
    log(msg) if @log_detail_lv > 0
  end

  def log_lv(lv, msg)
    log(msg) if @log_detail_lv >= lv
  end    
end  

require 'log_filters/log_rules.rb'

module LoggingRules
  include LoggingClassRules
  include LoggingMethodRules
  include LoggingTemplateRules
end

module LogExt
  include LogOutput
  include LoggingRules
end