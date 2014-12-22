class QuizPdf < Prawn::Document
  
  def initialize(quiz)
    super()
    @quiz = quiz
    quiz_name
    quiz_categories
    
  end
  
  def quiz_name
    text "Quiz #{@quiz.name}", size: 30, style: :bold
  end
  
  def quiz_categories
    move_down 20
    @quiz.categories.each do |c|
      category(c)      
    end
  end
  
  
  def category(category) 
    text "Category #{category.name}", size: 20, style: :bold
    move_down 2
    category.questions.each do |q|
      line_items(q)
      #question(q)
    end
  end
  
  def line_items(question)
    move_down 20
    table line_item_rows(question) do
      row(0).font_style = :bold
      #self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
    end
  end
  
  def line_item_rows(question)
    [["Correct", strip_html_tags(question.text)]] +
    question.answers.map do |a|
      ["#{a.correct? ? 'x' : ' '}", strip_html_tags(a.text)]
    end
  end
  
  
  def question(question)
    move_down 2
    text "Question: #{question.text}", style: :bold
    question.answers.each do |a|
      answer(a)
    end
  end
  
  def answer(answer)
    move_down 1
    text "[#{answer.correct? ? 'x' : ' '}] #{answer.text}"
  end
  
  def strip_html_tags(html_string)
    without_html_tags = ActionView::Base.full_sanitizer.sanitize(html_string)
    CGI.unescape(without_html_tags)
  end
  
end