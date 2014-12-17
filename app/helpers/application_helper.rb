module ApplicationHelper
  
  def preview_html_field(field, chars=nil)
    if chars.present?
      field[0..chars].strip.html_safe + " ..."
    else
      field.strip.html_safe
    end
  end
 
  
end
