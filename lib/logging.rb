# TODO:
# This module has grown way too large and complex. Should be redesigned, refactorea and split up
# Also we should use trace_calls.rb TraceCalls module instead of hardcoding all those BEGIN/END logging statements!
# That should make Logging much less intrusive!
require 'log_ext'
require 'log_file'
require 'trace_calls'

module Logging
  include LogExt

  def setup_overwrites
    # overwrite existing erb files ?
    @overwrite_view_erbs ||= true
    @overwrite_taglib_erbs ||= false

    # overwrite logging files ?
    @overwrite_logs ||= true
    @overwrite_dryml_log ||= true
  end    

  def setup
    # create Logger 
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

    setup_overwrites
    setup_template_rules
    setup_class_and_method_rules
    
    @log_method_stack = []    
  end


  def log(msg)
    return if msg.nil?
    setup if !@log

    # should I log inside this class?
    return if !log_class?(msg)
    
    # TODO: should I log inside this method? 
    # use log call stack! push on BEGIN, pop on END 

    return if !log_method?(msg)

    # TODO: If inside method, use number of items on stack as identation       
    if method_pos(msg) && @log_method_stack.size > 0
      identation = ""
      @log_method_stack.size.times { identation << " "}
      msg = identation + msg
    end
    
    # should I log this template?    
    if log_template?(@template_path)
      file = @template_path + '.log'
      # only log to .log file if corresponding .dryml file exists!
      if File.exist?(@template_path)
        LogFile::log_f(msg, file)
      end
    else
       @log.debug msg if @console_log
       LogFile::log_dryml(msg) if @generate_dryml_logfile
    end
  end  
   
end


