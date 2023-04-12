frames = [ ['X'], [7, '/'], [9, '-'],['X'],['-', 8],[8, '/'],['-', 6], ['X'],['X'], ['X', 8, 1] ]


def initialize_obj(is_last)
    {
        current_value: 0,
        pending1: false,
        pending2: false,
        is_last: is_last,
        is_bonus: false,
        total: 0
    }
end
def handle_strike(roll) #, score_obj)
  if roll == 'X'
    self[:current_value] = 10
    self[:pending1] = true
    self[:pending2] = true
    self[:total] = 10
  end
end

def handle_spare(*args)
    roll = args[0][0]
    #p "roll: #{roll}"
    prev_score = args[0][1]
    #p  "prev: #{prev_score}"
    if roll == '/'
      self[:current_value] = 10 - prev_score
      self[:pending1] = true unless self[:is_last]
      self[:pending2] = false
      self[:total] = 10 - prev_score
    end
end

def handle_gutter(roll)
    self
end   

def handle_others(roll)
    if roll != 'X' && roll != '/' && roll != '-' && roll > 0 && roll < 10
      self[:current_value] = roll
      self[:total] = roll unless self[:is_last]
    end
end

def evaluate_roll(roll, score_obj, prev_score = 0)
  rules = ["handle_strike", "handle_spare", "handle_gutter", "handle_others"]  
  rules.each do |rule|
    if rule == "handle_spare"
      score_obj.send(rule, [roll, prev_score])
    else  
      score_obj.send(rule, roll)
    end 
  end
  score_obj
end

def update_pending_scores(scores, val)
  if scores.length > 0 && scores.last[:pending1] 
    scores.last[:pending1] = false
    scores.last[:total] += val
  end
  if scores.length > 1 && scores[-2][:pending2]
    scores[-2][:pending2] = false
    scores[-2][:total] += val 
  end    
end

scores = []

p scores.each{|s| p s}
p scores.inject(0){|acc, el| acc + el[:total] unless el[:pending1] || el[:pending2]}