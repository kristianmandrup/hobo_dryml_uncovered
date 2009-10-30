module LogFile
  def is_old_file?(file)
    File.new(file).mtime < (Time.now - 20.seconds)
  end

  # write to global 'dryml_template' file in /log
  def log_dryml(txt)
    file = RAILS_ROOT + "/log/#{@log_file}.log"
    unless File.exist?(file) && !@overwrite_dryml_log
      mode = is_old_file?(file) && @overwrite_dryml_log ? "w+" : "a+"

      txt = ("#{Time.now}\n" + txt) if mode == "w+"
      open(file, mode) do |f|
        f.puts txt
      end
    end
  end

  # write to individual log file if provided, otherwise log to 'dryml_template' file in /log
  def log_f(txt, file = nil)
    if file
      unless File.exist?(file) && !@overwrite_logs
        mode = is_old_file?(file) && @overwrite_logs ? "w+" : "a+"
        txt = ("#{Time.now}\n" + txt) if mode == "w+"      
        open(file, mode) do |f|
          f.puts txt
        end
      end
    else
      log_f(txt)
    end
  end
end

def _log_report(file)
  file = file || (RAILS_ROOT + "/log/dryml_report.log")

  mode = File.exist?(file) && !is_old_file?(file) ? "a+" : "w+"
  txt = ("#{Time.now} : " + file.to_s)
  open(file, mode) do |f|
    f.puts txt
  end
end

module SaveErb  
  def save_erb_file(erb, file = nil)
    file = file || (RAILS_ROOT + "/" + @template_path + ".erb")

    # TODO: how much of this is still necessary?
    unless (File.basename(@template_path, '.dryml') == 'application') || @template_path.include?('taglibs')
      unless File.exist?(file) && !@overwrite_view_erbs      
        File.open(file, "w+") do |erbfile|
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
      dir = RAILS_ROOT + "/app/views/taglibs/erb/"
      FileUtils.mkdir_p(dir) unless File.directory?(dir)      
      file = File.join(dir, "#{taglib}.dryml.erb")
      unless File.exist?(file) && !@overwrite_taglib_erbs
        File.open(file, "w+") do |f|
          f.puts env_src
        end
      end
    end
  end
end