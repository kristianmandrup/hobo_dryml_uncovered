require 'logger'

class String
  def blank?
    return true if self.nil? || self.strip.empty?        
    false
  end
end

class Logging
  
  def log_detail(msg)
    # log(msg)
  end
  
  def do_log?(template, options)
    includes = options[:includes]
    excludes = options[:excludes]
    default = options[:default]
    
    return false if !template || template.blank? 
    return false if excludes && excludes.include?(template)     
    return true if includes && includes.include?(template) 
    return default
  end
  
  def log_exclude?(template, options)
    excludes = options[:excludes]    
    return true if excludes && excludes.include?(template) 
    return !options[:default]    
  end

  def log_include?(template, options)
    excludes = options[:excludes]    
    return true if excludes && excludes.include?(template) 
    return options[:default]
  end

  
  def log_template?(template)
    return false if !template
    
    # directory of template file
    template_dir = File.dirname(template)
    # basename is filename part of path
    template_filename = File.basename(template)
    # remove extension to get template name
    template_name = File.basename(template, File.extname(template))
        
    # is this a taglib we are processing?
    if template_dir =~ /\/taglibs/
      # find part of template name before '_', by convention the name of the taglib ('core' and 'rapid' taglibs part of Hobo!)
      template_taglib = template_name.sub(/_(.*)/, '\2')
      return do_log?(template_taglib, @log_taglibs)

    elsif template_dir =~ /\/views\//      
      view_folder = template_dir.sub(/^(.*)\/views\/(.*?)$/, '\2')      
      # excluded view folder?
      return false if log_exclude?(view_folder, @log_view_folders)

      # if view folder is valid, test view templates
      if log_include?(view_folder, @log_view_folders)
        return do_log?(template_name, @log_views)        
      end
    end    

    # if all else fails, just do default log action!
    return @log_default
  end

  def setup
    @log ||= Logger.new(STDOUT)
    @log.level ||= Logger::DEBUG          
    @log_file ||= 'dryml_template'
    
    # fine tune logging
    @overwrite ||= false
    @console_log ||= false
    @generate_dryml_logfile ||= true               

    @log_default = true
    @log_view_folders = {:includes => 'front recipe', :excludes => 'ingredient', :default => true}        
    @log_views = {:includes => 'index show', :excludes => 'new', :default => false}    
    @log_taglibs = {:includes => 'rapid', :excludes => 'core', :default => false}    
  end
  
  def log(msg)
    setup if !@log
    if log_template?(@template_path)
      file = @template_path + '.log'
      if File.exist?(@template_path)
        log_f(msg, file)
      end
    else
       @log.debug msg if @console_log
       log_dryml(msg) if @generate_dryml_logfile
    end
  end  

  def is_old_file?(file)
    File.new(file).mtime < (Time.now - 20.seconds)
  end

  def log_dryml(txt)
    file = RAILS_ROOT + "/log/#{@log_file}.log"
    mode = is_old_file?(file) ? "w+" : "a+"
    
    txt = ("#{Time.now}\n" + txt) if mode == "w+"
    open(file, mode) do |f|
      f.puts txt
    end
  end

  def log_f(txt, file = nil)
    file = file || (RAILS_ROOT + "/log/#{@log_file}.log")
    unless File.exist?(file) && @overwrite
      mode = is_old_file?(file) ? "w+" : "a+"
      
      txt = ("#{Time.now}\n" + txt) if mode == "w+"      
      open(file, mode) do |f|
        f.puts txt
      end
    end
  end    
end

@my_log = Logging.new
@my_log.setup

def do_log?(path)
  puts "path: #{path} do log = #{@my_log.log_template?(path)}"
end

# TESTCASES

# do_log?("/app/views/front/index.dryml")
# do_log?("/app/views/recipe/index.dryml")
# do_log?("/app/views/ingredient/index.dryml")
# 
# do_log?("/app/views/front/show.dryml")
# do_log?("/app/views/recipe/show.dryml")
# do_log?("/app/views/ingredient/show.dryml")
# do_log?("/app/views/recipe/blip.dryml")
# do_log?("/app/views/cook/show.dryml") 

# do_log?("/app/views/front/new.dryml")
# do_log?("/app/views/recipe/new.dryml")
# do_log?("/app/views/ingredient/new.dryml")

# do_log?("/hobo/taglibs/rapid_core.dryml")
# do_log?("/hobo/taglibs/core.dryml")

