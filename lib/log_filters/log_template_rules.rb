module LoggingTemplateRules

  def setup_template_rules
    # logging fine tuning  
    @log_view_folders = {:includes => 'front recipe', :excludes => 'ingredient', :default => true}        
    @log_views = {:includes => 'index show', :excludes => 'new', :default => false}    
    @log_taglibs = {:includes => 'rapid', :excludes => 'core', :default => false}    
    @log_default = true    
  end
  
  # determine if we should log or not
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

end