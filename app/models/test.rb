class Test < ActiveRecord::Base
  belongs_to :user
  has_many :assignations
  has_many :questions, :through => :assignations
  has_many :tests
  enum test_type: { test: 0, pause: 1 , test_learnphase: 2, test_reproductionphase: 3, part_of_bkt: 4, guest_test: 5}
  
  
  #def get_first_assignation 
  #  t = self.first_test
  #  
  #  puts "+++++++++++++++++++++++++++++++++++++++++++++++++++"
  #  puts t.inspect
  #  
  #  assignation  = t.assignations.first    
  #end
  
  #def first_test
  #  t = self
  #  
  #  while t.tests.any?
  #    puts 'FIRST_TEST -> GO DEEPER'
  #    t = t.tests.first
  #  end
  #  
  #  first_test = t
  #end
  
  def assignation_array() 
    array = []
    
    count = self.assignation_count()
    #puts "COUNT: #{count}".yellow.on_black
    for i in 0..(count-1)
      #puts "ADD element".yellow.on_black
      array << self.assignation(i)
    end
      
    array
  end
  
  
  #def test_with_assignation_index(index)
  #  t = self
  #  assignation_count = 0
  #  
  #  while t.tests.any?
  #    #puts 'FIRST_TEST -> GO DEEPER'
  #    t = t.tests.first
  #  end
  #  
  #  first_test = t
  #end
  
  
  def assignation_count(options = {})
    assignations = options[:assignations]
    
    if assignations.present?
      return assignations.count
    end
    
    #puts "START COUNTING!"
    assignation_count = inorder_assignation_count(self)    
  end
  
  def index_of_first_assignation_of_next_leaf(assignation) 
    a = first_assignation_of_next_leaf(assignation)
    number = index_of_assignation_in_assignation_array(a)
  end
  
  def first_assignation_of_next_leaf(assignation) 
    next_leaf = next_leaf_from_assignation(self, assignation) 
    
    first_assignation = nil
    
    if next_leaf.assignations && next_leaf.assignations.any?
      first_assignation = next_leaf.assignations.first
    end
    
    first_assignation
  end
  
  
  def index_of_assignation_in_assignation_array(assignation)
    if assignation.blank?
      return -1
    end
    
    count = self.assignation_count()
    
    for i in 0..(count-1)
      a = self.assignation(i)
      if assignation == a
        return i
      end
    end
    
    return -1
  end
  
  
  def previous_leaf_from_assignation(test, assignation)
    #puts "next_leaf_from_assignation #{test.inspect}, #{assignation.inspect}".red.on_white
    if test.blank? || assignation.blank?
      return nil
    end
      
    i = 0
    loop do 
      leaf = test.leaf(i)
      #puts "checking leaf: #{leaf.inspect}".red.on_white
      break if leaf.blank?
      
      if leaf.assignations.include?(assignation)
        leaf = test.leaf(i-1)
        #puts "THE MATCH!!!! #{leaf.inspect}".red.on_white
        return leaf
      end
      
      i+=1
    end
  end
  
  def next_leaf_from_assignation(test, assignation) 
    #puts "next_leaf_from_assignation #{test.inspect}, #{assignation.inspect}".red.on_white
    if test.blank? || assignation.blank?
      return nil
    end
      
    i = 0
    loop do 
      leaf = test.leaf(i)
      #puts "checking leaf: #{leaf.inspect}".red.on_white
      break if leaf.blank?
      
      if leaf.assignations.include?(assignation)
        leaf = test.leaf(i+1)
        #puts "THE MATCH!!!! #{leaf.inspect}".red.on_white
        return leaf
      end
      
      i+=1
    end
  end
  
  
  def leaf(number)
    #puts "START FINDING LEAF ***********************************************************************"
    @found_leaf = nil    
    
    #TODO check if works, otherwise try to put on first place of method
    #DO NO RECURSION
    if self.tests.none? && number <= 0
      #puts "FINDING_RESULT: #{@found_leaf.inspect} (<- ONLY LEAF)"
      return self
    end
    
    #DO RECURSION
    find_leaf(self, number, -1)
    #puts "FINDING_RESULT: #{@found_leaf.inspect}"
    @found_leaf
  end
  
  def assignation(index)
    #puts "START FINDING ASSIGNATION ##{index} ***********************************************************************".yellow
    
    assignation_count = 0
    assignation_index = 0
    
    i = 0    
    leaf = leaf(i)
    while leaf
      i += 1
      
      if leaf.assignations
        assignation_count += leaf.assignations.count
      end
      
      #puts "ASSIGNATION COUNT: #{assignation_count}"
      
      if assignation_count >= (index+1)
        assignation_index = index - assignation_count 
        break;
      end
      
      #puts "GOTO NEXT LEAF"
      leaf = leaf(i)
    end
    
    assignation_match = nil
    
    if leaf
      assignation_match = leaf.assignations[assignation_index]
    end
    
    #puts "ASSIGNATION MATCH: #{assignation_match.inspect}".red.on_blue
    
    return assignation_match
  end
  
 

  #def next_assignation(index)
  #  next_assignation = nil
  #      
  #  if self.assignations[index+1]
  #    next_assignation = self.assignations[index+1]
  #  end
  #  
  #  next_assignation
  #end
  
  
  def score(options = {})
    count = 0;
    
    assignations = options[:assignations]
    
    if assignations.blank?
      assignations = self.assignation_array()
    end

    assignations.each do |a|
      #ATTENTION: we skip learnphase assignations!
      if a.test.test_learnphase? 
        next
      end
      
      count+=1 if a.passed?
    end
    count
  end
  
  
  def max_score(options = {})
    count = 0;
    
    assignations = options[:assignations]
    
    if assignations.blank?
      assignations = self.assignation_array()
    end

    assignations.each do |a|
      #ATTENTION: we skip learnphase assignations!
      if a.test.test_learnphase? 
        next
      end
      
      count+=1
    end
    count
  end

  
  def score_in_percent(options = {})
    percent = 0
    max_score = self.max_score(options)
    return percent if max_score == 0
    score = self.score(options)
    result = (100 * score) / max_score
  end
  
  
  
  
  
  
  
  
  def passed_assignation_count(options = {})
    count = 0;
    
    assignations = options[:assignations]
    
    if assignations.blank?
      assignations = self.assignation_array()
    end

    assignations.each do |a|
      count+=1 if a.passed?
    end
    count
  end
  
  def result_in_percent(options = {})
    total = assignation_count(options) #assignations.count 
    passed = passed_assignation_count(options)
    result = (100 * passed) / total 
  end
  
  def duration_in_sec
    sec = nil
    
    if self.start.present? && self.end.present?
      sec = (self.end - self.start)#.strftime("%H:%M:%S")
    end
    
    sec
  end
  
  
  
  private
  
  
  def inorder_assignation_count(test)
    #puts "INORDER_ASSIGNATION_COUNT (#{test.id})"
    
    if test.tests.any?
      count = 0
      test.tests.each do |subtest|
        count += inorder_assignation_count(subtest)
      end
      return count
    else
      if test.assignations.any?
        #puts "END REACHED: #{test.assignations.count}"
        return test.assignations.count
      else
        return 0
      end
    end
  end
  
  def find_leaf(test, leaf_number, leaf_counter)
    #puts "FIND_LEAF (#{test.id}, #{leaf_number}, #{leaf_counter})"
  
    if test.tests.any?
      test.tests.each do |subtest|
        leaf_counter = find_leaf(subtest, leaf_number, leaf_counter)
        #puts "CHECK: #{subtest.id}, leafnumber: #{leaf_number}, counter: #{leaf_counter}"
        leaf_was_found = (leaf_number == leaf_counter)
        if leaf_was_found
          #puts "BINGO! #{subtest.id}"
          @found_leaf = subtest # assign result
          return (leaf_counter+1) # increase counter, so following leafs will not overwrite the found_leaf
        end
      end
      return leaf_counter #no leaf, hence do not increase
    else
      #puts "LEAF REACHED: #{test.id}, leafnumber: #{leaf_number}, counter: #{leaf_counter}"
      return (leaf_counter+1)
    end
  end
  
  
end
