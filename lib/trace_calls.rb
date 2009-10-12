require 'trace_ext'

module TraceCalls
    
  def self.included(klass)
    suppress_tracing do
      klass.instance_methods(false).each do |existing_method|
        wrap(klass, existing_method)
      end
    end
    def klass.method_added(method)  # note: nested definition
      unless @trace_calls_internal
        @trace_calls_internal = true
        TraceCalls.wrap(self, method)
        @trace_calls_internal = false
      end
    end
  end
    
  def self.suppress_tracing
    Thread.current[:'suppress tracing'] = true
    yield
  ensure
    Thread.current[:'suppress tracing'] = false
  end

  def self.ok_to_trace?(name)
    !Thread.current[:'suppress tracing']
  end      

  def self.wrap(klass, method) 
    klass.class_eval do
      name = method.to_s
      original_method = instance_method(name)

      define_method(name) do |*args, &block|
        if TraceCalls.ok_to_trace?(name)
          TraceCalls.suppress_tracing do
            if trace_method?(name)   
              method_stack.push(name)           
              output "==============================================="                      
              output "==> #{self.class}.#{name} : BEGIN" 
              output "-----------------------------------------------"                      
              output "#{args.inspect}" 
              output "-----------------------------------------------"                      
              output "#{'(and a block)' if block_given?}"
              output "-----------------------------------------------" if block_given?            
            end
          end
        end
        result = original_method.bind(self).call(*args, &block)
        if TraceCalls.ok_to_trace?(name)
          TraceCalls.suppress_tracing do          
            if trace_method?(name)     
              output "<<= #{self.class}.#{name} : END"
              output "-----------------------------------------------"          
              output "#{result}"
              output "==============================================="                                
            end
          end
        end
        res = result
        if TraceCalls.ok_to_trace?(name)
          TraceCalls.suppress_tracing do          
            if trace_method?(name)                        
              method_stack.pop      
            end
          end
        end 
        res         
      end
    end
  end
  
  suppress_tracing do
    include TraceExt
  end  
end