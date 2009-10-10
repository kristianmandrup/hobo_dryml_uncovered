module Context
  def set_context(context)
    @context = context
  end
end  


module Logging
  
  def log_detail(msg)
    # log(msg)
  end
  
  def log(msg)
    @log ||= Logger.new(STDOUT)
    @log.level ||= Logger::DEBUG          
    @log_file ||= 'dryml_template'
    @overwrite = false
    @console_log = false
    
    if @template_path
      file = @template_path + '.log'
      if File.exist?(@template_path)
        log_f(msg, file)
      end
    else
       @log.debug msg if @console_log
       log_dryml(msg)
    end
  end  

  def is_old_file?(file)
    File.new(file).mtime < (Time.now - 20.seconds)
  end

  def log_dryml(txt)
    file = RAILS_ROOT + "/log/#{@log_file}.log"
    mode = is_old_file?(file) ? "w+" : "a+"
    open(file, mode) do |f|
      f.puts txt
    end
  end

  def log_f(txt, file = nil)
    file = file || (RAILS_ROOT + "/log/#{@log_file}.log")
    unless File.exist?(file) && @overwrite
      mode = is_old_file?(file) ? "w+" : "a+"
      open(file, mode) do |f|
        f.puts txt
      end
    end
  end
    
end

module SaveErb  
  def save_erb_file(erb, file = nil)
    file = file || (RAILS_ROOT + "/" + @template_path + ".erb")
    unless (File.basename(@template_path, '.dryml') == 'application') || @template_path.include?('taglibs')
      unless File.exist?(file) && @overwrite      
        File.open(file, "w") do |erbfile|
          erbfile.syswrite(erb)
        end
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