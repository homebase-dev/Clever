#to test simply do a db:migrate, it executes this

Settings.defaults[:next_med_exam_date] = '2016/07/01'
Settings.defaults[:membership_price_euro] = 29.90
Settings.defaults[:membership_season_end_date] = '2016/07/03'
#Settings.defaults[:take_categories_from_quizzes_with_id] = "1" #do this over attribute published from quiz
Settings.defaults[:test_number_contexts] = 10
Settings.defaults[:test_number_questions] = 10
Settings.defaults[:send_invoice_to_customer] = false

#Settings.save_default(:next_med_exam_date, '01/07/15')
#Settings.save_default(:membership_price_euro, 29.90)
#Settings.save_default(:test_number_contexts, 10)
#Settings.save_default(:test_number_questions, 10)

#Settings.get_all.each do |setting|
#  puts setting
#end


