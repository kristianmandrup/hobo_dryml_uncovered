module DrymlTraceRules

  def dryml_methods
    {
      'Template' => {
      # Hobo::Dryml::Template.singleton_methods(false)
        :singleton_methods => ["clear_build_cache", "build_cache"],          
      # Hobo::Dryml::Template.instance_methods(false)
        :instance_methods => ["field_shorthand_element?", "polymorphic_call_type", "parameter_tag_hash_item", "node_to_erb", 
          "tag_call", "wrap_tag_method_body_with_metadata", "current_def_name", "require_attribute", 
          "element_line_num", "apply_control_attributes", "is_taglib?", "get_param_name", "strip_suppressed_whiteaspace", 
          "contains_param?", "tags", "set_scoped_element", "process_src", "prepend_parameter_tag_hash_item", 
          "include_element", "tag_method_body", "part_delegate_tag_name", "compile", "logger", "ctx_str", 
          "without_parameters", "ruby_name", "param_names_in_definition", "delegated_part_element", "extend_element", 
          "before_parameter_tag_hash_item", "dryml_exception", "tag_method", "part_element", "tag_attributes", 
          "static_element_to_erb", "call_to_self_from_type_specific_def?", "type_specific_suffix", "wrap_source_with_metadata", 
          "import_module", "param_proc", "element_to_erb", "declared_attributes", "template_path", "param_restore_local_name", 
          "bundle", "restore_erb_scriptlets", "param_content_element", "param_content_local_name", "merge_attribute", 
          "create_render_page_method", "append_parameter_tag_hash_item", "tag_newlines", "inside_def_for_type?", 
          "define_polymorphic_dispatcher", "simple_part_element", "attribute_to_ruby", "has_context?", 
          "rename_class", "wrap_tag_call_with_metadata", "call_name", "children_to_erb", "wrap_replace_parameter", 
          "set_element", "gensym", "after_parameter_tag_hash_item", "maybe_make_part_call", "static_tag_to_method_call", 
          "with_containing_tag_name", "default_param_proc", "parameter_tags_hash", "require_toplevel", "is_code_attribute?", 
          "old_tag_call?", "def_element", "replace_parameter_proc", "find_ancestor", "include_source_metadata", 
          "compile_merge_attrs", "promote_static_tag_to_method_call?"],



        :core => ['compile', 'create_render_page_method', 'is_taglib?', 'process_src', 'restore_erb_scriptlets', 
          'children_to_erb', 'node_to_erb', 'element_to_erb'],
        :element => ['include_element', 'tag_newlines', 'def_element', 'extend_element', 'set_element', 'set_scoped_element', 
          'param_content_element', 'tag_call', 'static_element_to_erb']
          
        :element_support => ['define_polymorphic_dispatcher', 'tag_method', 'tag_method_body', 'wrap_source_with_metadata', 
          'wrap_tag_method_body_with_metadata', 'wrap_tag_call_with_metadata']  
        
        # group by multiple dimension, fx what they output?
          
        :extra => ['import_module', 'declared_attributes', 'parameter_tags_hash', 'param_content_local_name', 'param_content_element',
        'part_element', 'simple_part_element', 'part_delegate_tag_name', 'call_name', 'polymorphic_call_type',
        'append_parameter_tag_hash_item', 'prepend_parameter_tag_hash_item', 'default_param_proc',
        'param_proc', 'replace_parameter_proc', 'maybe_make_part_call', 'tag_attributes', 'compile_merge_attrs'                
        ]
      },

      'TemplateEnvironment' => {         
        :singleton_methods =>   ["tag_attrs", "load_time", "load_time=", "compiled_local_names", "_register_tag_attrs", 
          "compiled_local_names=", "delayed_alias_method_chain", "inherited"],

      # Hobo::Dryml::TemplateEnvironment.instance_methods(false)      
        :instance_methods => ["this_key", "form_field_path", "_tag_context", "with_form_context", "element", "this_parent", "part_contexts", 
          "this_key=", "typed_id", "call_part", "repeat_attribute", "register_form_field", "_tag_locals", "this", 
          "attrs_for", "with_part_context", "find_form_field_path", "view_name", "this_field_reflection", 
          "scope", "new_field_context", "erb_binding", "path_for_form_field", "add_classes!", "call_tag_parameter", 
          "part_contexts_javascripts", "part_contexts_storage", "session", "form_field_names", "this_type", "merge_attrs", 
          "new_context", "new_object_context", "call_tag_parameter_with_default_content", "merge_parameter_hashes", 
          "form_this", "add_classes", "call_polymorphic_tag", "find_polymorphic_tag", "merge_tag_parameter", "method_missing", 
          "this_field", "refresh_part", "override_and_call_tag", "render_tag"],          

        :core => ['call_part', 'refresh_part', 'with_part_context', 'call_polymorphic_tag', 'find_polymorphic_tag', 'repeat_attribute'
          'new_context', 'new_object_context', 'new_field_context' 'find_form_field_path', 'with_form_context', 'call_tag_parameter_with_default_content', 
          'call_tag_parameter', 'override_and_call_tag', 'merge_tag_parameter']        
      },    

      'Taglib'     { 
        :singleton_methods => [],
      # Hobo::Dryml::Taglib.instance_methods(false)
        :instance_methods => ["import_into", "load", "reload"]
        :core => ['load']
      },
      'DRYMLBuilder' => {
        :singleton_methods => [],
      # Hobo::Dryml::DRYMLBuilder.instance_methods(false)        
        :instance_methods => ["start", "add_build_instruction", "import_module", "ready?", "set_context", 
        "<<", "template", "template_path", "erb_process", "set_environment", "build", "import_taglib", 
        "add_part", "render_page_source", "set_theme"],
        :core => ['build', 'start', 'add_build_instruction', 'import_taglib']                
      },
      # Hobo::Dryml::TemplateHandler.instance_methods(false)
      'TemplateHandler' => {        
        :singleton_methods => [],
        :instance_methods =>  ["compile", "render_for_rails22", "render"]      
      }
    }
  end
    
end

