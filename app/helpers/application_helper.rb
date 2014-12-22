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
  
  
  

 
  
end
