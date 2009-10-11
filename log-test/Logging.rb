require 'logger'

class String
  def blank?
    return true if self.nil? || self.strip.empty?        
    false
  end
end

class Logging
  
  # use to control detail lv of logging
  def log_detail(msg)
    log(msg) if @log_detail_lv > 0
  end

  def log_lv(lv, msg)
    log(msg) if @log_detail_lv >= lv
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

    # control detail lv of logging 
    # currently only controls logging of 'src' for build instruction in DRYMLBuilder
    @log_detail_lv = 0
    # global dryml logging file (written to /log folder)         
    @log_file ||= 'dryml_template'

    # fine tune logging

    # ouput log to console?
    @console_log ||= false

    # generate log/dryml_template.log ?
    @generate_dryml_logfile ||= true               

    # overwrite existing erb files ?
    @overwrite_view_erbs ||= true
    @overwrite_taglib_erbs ||= false
    
    # overwrite logging files ?
    @overwrite_logs ||= true
    @overwrite_dryml_log ||= true

    # logging fine tuning  
    @log_view_folders = {:includes => 'front recipe', :excludes => 'ingredient', :default => true}        
    @log_views = {:includes => 'index show', :excludes => 'new', :default => false}    
    @log_taglibs = {:includes => 'rapid', :excludes => 'core', :default => false}    
    @log_default = true  
    
    # fine tuning by dryml class
    @log_dryml_classes = {:includes => ['TemplateEnvironment'], :excludes => ['Taglib'], :default => true}    
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
      return false if @log_dryml_classes[:excudes].include?(class_name(msg))
      return true if @log_dryml_classes[:includes].include?(class_name(msg))
    end
    return @log_dryml_classes[:default] || true
  end

  def log(msg)
    setup if !@log
  
    return if !log_class?(msg)      
    
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

@my_log = Logging.new
@my_log.setup

def do_log?(path)
  puts "path: #{path} do log = #{@my_log.log_template?(path)}"
end

# TESTCASES

do_log?("/app/views/front/index.dryml")
do_log?("/app/views/recipe/index.dryml")
do_log?("/app/views/ingredient/index.dryml")
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

