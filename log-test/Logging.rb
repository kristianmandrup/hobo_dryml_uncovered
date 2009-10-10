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
  
  def log_template?(template)
    return false if !template
    
    # directory of template file
    template_dir = File.dirname(template)
    # basename is filename part of path
    template_filename = File.basename(template)
    # remove extension to get template name
    template_name = template_filename.sub(/\.*?/, '')
    
    # is this a taglib we are processing?
    if template_dir =~ /\/taglibs\//
      return false if !@log_taglibs

      # find part of template name before '_', by convention the name of the taglib ('core' and 'rapid' taglibs part of Hobo!)
      template_taglib = template_dir.sub(/(.*?)_/, "\1")
      if !template_taglib.blank?
        return false if @log_exclude_taglibs.include?(template_taglib)          
      end    

    elsif template_dir =~ /\/views\//      
      view_folder = template_dir.sub(/^(.*)\/views\/(.*?)$/, "\1")

      return false if @log_view_folders_exclude && @log_view_folders_exclude.include?(view_folder)

      if !@log_view_folders || @log_view_folders.blank? || @log_view_folders.include?(view_folder)
        if !@log_views || @log_view_folders.blank? || @log_views.include?(template_name)
          return true
        end
      end
    end    

    # if all else fails, just log it!
    return true
  end

  def setup
    # @log ||= Logger.new(STDOUT)
    # @log.level ||= Logger::DEBUG          
    @log_file ||= 'dryml_template'
    
    # fine tune logging
    @overwrite ||= false
    @console_log ||= false
    @log_dryml ||= true
    @log_rapid ||= false
    @log_taglibs ||= false 
    # specify which view folders to include for logging
           
    @log_view_folders ||= 'front recipe'
    @log_view_folders_exclude ||= 'ingredient'    
    
    @log_views ||= 'index show'
    @log_views_exclude ||= 'new'
    
    @log_exclude_taglibs ||= 'rapid core'
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
       log_dryml(msg) if @log_dryml
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

do_log?("/app/views/front/index.dryml")
do_log?("/app/views/recipe/index.dryml")
do_log?("/app/views/ingredient/index.dryml")

do_log?("/app/views/front/show.dryml")
do_log?("/app/views/recipe/show.dryml")
do_log?("/app/views/ingredient/show.dryml")

do_log?("/app/views/front/new.dryml")
do_log?("/app/views/recipe/new.dryml")
do_log?("/app/views/ingredient/new.dryml")

do_log?("/hobo/taglibs/rapid_core.dryml")
do_log?("/hobo/taglibs/core.dryml")

