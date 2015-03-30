#to test simply do a db:migrate, it executes this

#Settings.defaults[:next_med_exam_date] = '01/07/15'
#Settings.defaults[:membership_price_euro] = 29.90
#Settings.defaults[:test_number_contexts] = 10
#Settings.defaults[:test_number_questions] = 10

Settings.save_default(:next_med_exam_date, '01/07/15')
Settings.save_default(:membership_price_euro, 29.90)
Settings.save_default(:test_number_contexts, 10)
Settings.save_default(:test_number_questions, 10)

#Settings.get_all.each do |setting|
#  puts setting
#end


