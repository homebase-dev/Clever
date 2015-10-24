module ApplicationHelper
  
  def preview_html_field(field, first_n_chars=nil)
    if first_n_chars.present? && field.length > first_n_chars
      "#{field[0..first_n_chars].strip.html_safe} ..."
    else
      if field.blank?
          "&nbsp;".html_safe
        else
          field.strip.html_safe
      end
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
  
  def number_to_euro(amount) 
    number_to_currency(amount,:unit=>'€')
  end
  
  def membership_price_euro
    number_to_euro(Settings[:membership_price_euro])
  end
  
  def meta_keywords
    keywords = %w(aufnahmetest-medizin Vorbereitung-medizin-test medizin-aufnahmeprüfung MedAt-2016-vorbereitung Eignungstest-medizin-online Medizin-aufnahmetest-2016 medizin-vorbereitungskurs-innsbruck-wien-graz-linz Medizin-aufnahmetest-innsbruck-wien-graz-linz Medizin-aufnahmetest-vorbereitung aufnahmetest-online medizin-aufnahmetest-übungen aufnahmetest-vorbereitung-medat aufnahmetest-fragen medizinischer-eignungstest-vorbereiten medat-2016-vorbereitung medizinertest-innsbruck vorbereitungskurs-medizin-aufnahmetest)   
    keywords.join(',')
  end
  
  def meta_description
    description = "Online Vorbereitung für den Medizin Aufnahmetest (MedAT) inklusive kostenlose Skripten für Biologie, Physik, Chemie und Mathematik; unzählige Gesamttest mit Zufallsgenerator; alle Untertests wie Kognitive Fähigkeiten, Biologie etc. einzeln üben, Lernstatistiken analysieren und gezielt üben"
  end
    
end
