module Context
  def set_context(context)
    @context = context
  end
end  


module Logging
  
  def log(msg)
    @log ||= Logger.new(STDOUT)
    @log.level ||= Logger::DEBUG          
    @log_file ||= 'dryml_template'
#    @old_template ||= ''
    
    if @template_path # && @template_path.include?('app/views/') || !@template_path.include?('views/taglibs')
      file = @template_path + '.log'
      log_f(msg, file)
    else
       @log.debug msg
       log_f(msg)
    end
  end  

  def log_f(txt, file = nil)
    file = file || (RAILS_ROOT + "/log/#{@log_file}.log")
    open(file, "a+") do |f|
      f.puts txt
    end
  end
    
end

module SaveErb  
  def save_erb_file(erb, file = nil)
    file = file || (RAILS_ROOT + "/" + @template_path + ".erb")
    unless (File.basename(@template_path, '.dryml') == 'application') || @template_path.include?('taglibs')
      File.open(file, "w") do |erbfile|
        erbfile.syswrite(erb)
      end
    end
    erb
  end
end

module SaveEnv  
  def save_environment_file(tag_name, env_src, taglib)
    if tag_name
      dir = RAILS_ROOT + "/app/views/taglibs/rapid/"
      FileUtils.mkdir_p(dir) unless File.directory?(dir)      
      file = File.join(dir, "#{taglib}.dryml.erb")
      unless File.exist?(file)
        File.open(file, "w+") do |f|
          f.puts env_src
        end
      end
    end
  end
end