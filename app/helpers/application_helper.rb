module ApplicationHelper
  
  def preview_html_field(field, first_n_chars=nil)
    if first_n_chars.present?
      "#{field[0..first_n_chars].strip.html_safe} ..."
    else
      field.strip.html_safe
    end
  end
  
  
  def render_boolean(value)
    if value
      raw '<span class="glyphicon glyphicon-ok" aria-hidden="true" style="color: #5cb85c"><span>'
    else
      raw '<span class="glyphicon glyphicon-remove" aria-hidden="true" style="color: #d9534f"><span>'
    end
  end
  
    
  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end
    
end
