class InvoicePdf < Prawn::Document

  def initialize(user, invoice)
    super()
    @user = user
    #@result = result
    
    date_format = "%d.%m.%Y"
    
    @invoice_number = invoice.id
    @subscription_start = Time.new.strftime(date_format)
    @subscription_end = "1. Juli des Folgejahres"
  
    next_exam_date_string = Settings.next_med_exam_date
    if next_exam_date_string.present? 
      next_exam_date = Date.strptime(next_exam_date_string, "%Y/%m/%d")
      @subscription_end = next_exam_date.strftime(date_format)
    end

    #@price_netto = ((invoice.amount/120) * 100).round(2)
    #@price_tax = (invoice.amount - @price_netto).round(2)
    #@price_total = (@price_netto + @price_tax).round(2)
    @price_total = invoice.amount

    #@price_netto = ApplicationController.helpers.number_to_currency(@price_netto, unit: "€", separator: ".", delimiter: "", format: "%u %n")
    #@price_tax = ApplicationController.helpers.number_to_currency(@price_tax, unit: "€", separator: ".", delimiter: "", format: "%u %n")
    @price_total = ApplicationController.helpers.number_to_currency(@price_total, unit: "€", separator: ".", delimiter: "", format: "%u %n")

    #font :Helvetica, :style => :normal
    header
    body
  end

  def header
    text "MMag. Stefan Stillebacher\nSaglstraße 64\n6410 Telfs\nUID-Nr. ATU67516912", :align => :right, :leading => 10
  end
  
  def body
    stroke_horizontal_rule
    
    move_down 80
    text "Telfs, #{@subscription_start}", :align => :right
    move_down 60
    
    text "Registrierung online Übungs-Plattform aufnahmetest.at \nRe-Nr. #{@invoice_number}", :style => :bold, :leading => 10
    
    move_down 30
    
    text "Rechnungsbetrag zur Nutzung der Online Plattform aufnahmetest.at von #{@subscription_start} bis zum #{@subscription_end}:", :leading => 10
    
    move_down 30
    
    price_table
    
    move_down 30
    
    text "Wir wünschen Ihnen alles Gute!\nBeste Grüße\nMMag. Stefan Stillebacher", :leading => 20
  end
  
  def price_table
    #data = [["Nettobetrag", "#{@price_netto}"], ["20% Umsatzsteuer", "#{@price_tax}"], ["Gesamt", "#{@price_total}"]]
    data = [["Gesamt", "#{@price_total}"]]
    table(data, :position => :right, :column_widths => [135, 135])  do
      row(2).font_style = :bold
      column(1).align = :right
    end
  end
  
  
  
  
  
  
  
  
  
  
  
  
  
  def logo
    logopath =  "#{Rails.root}/app/assets/images/logo.png"
    image logopath, :width => 197, :height => 91
    move_down 10
    draw_text "Receipt", :at => [220, 575], size: 22
  end
  
  
  def thanks_message
    move_down 80
    text "Hello #{@user.fullname.capitalize},"
    move_down 15
    text "Thank you for your order.Print this receipt as 
    confirmation of your order.",
    :indent_paragraphs => 40, :size => 13
  end

  def subscription_date
    move_down 40
    text "Subscription start date: 
    #{@invoice.start_date.strftime("%d/%m/%Y")} ", :size => 13
    move_down 20
    text "Subscription end date :  
    #{@invoice.end_date.strftime("%d/%m/%Y")}", :size => 13
  end

  def subscription_details
    move_down 40
    table subscription_item_rows, :width => 500 do
      row(0).font_style = :bold
      columns(1..3).align = :right
      self.header = true
      self.column_widths = {0 => 200, 1 => 100, 2 => 100, 3 => 100}
    end
  end

  def subscription_amount
    #subscription_amount = 20
    #vat = 10
    #delivery_charges = 5
    #sales_tax =  3
    #table ([["Vat (12.5% of Amount)", "", "", "#{precision(vat)}"] ,
    #["Sales Tax (10.3% of half the Amount)", "", "",
    #"#{precision(sales_tax)}"]   ,
    #["Delivery charges", "", "", "#{precision(delivery_charges)}  "],
    #["", "", "Total Amount", "#{precision(55) }  "]]), 
    #  :width => 500 do
    #    columns(2).align = :left
    #    columns(3).align = :right
    #    self.header = true
    #    self.column_widths = {0 => 200, 1 => 100, 2 => 100, 3 => 100}
    #    columns(2).font_style = :bold
    #  end
  end

  def subscription_item_rows
    [["Description", "Quantity", "Rate", "Amount"]] +
    @invoice.subscriptions.map do |subscribe|
      [ "#{subscribe.description} ", subscribe.quantity, 
      "#{precision(subscribe.rate)}  ",  
      "#{precision(subscribe.quantity  * subscribe.rate)}" ]
    end
  end

  def precision(num)
    @view.number_with_precision(num, :precision => 2)
  end

  def regards_message
    move_down 50
    text "Thank You," ,:indent_paragraphs => 400
    move_down 6
    text "XYZ",
    :indent_paragraphs => 370, :size => 14, style:  :bold
  end

end