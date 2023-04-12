class Score
    attr_reader :current_value, :total
    def initialize(is_last)
        @current_value = 0
        @pending1 = false
        @pending2 = false
        @is_last = is_last
        @is_bonus = false
        @total = 0
    end
    def handle_strike(roll)
        if roll == 'X'
          @current_value = 10
          @pending1 = true
          @pending2 = true
          @total = 10
        end
    end
      
    def handle_spare(*args)
          roll = args[0][0]
          prev_score = args[0][1]
          if roll == '/'
            @current_value = 10 - prev_score
            @pending1 = true unless @is_last
            @pending2 = false
            @total = 10 - prev_score
          end
      end
      
      def handle_gutter(roll)
      end   
      
      def handle_others(roll)
          if roll != 'X' && roll != '/' && roll != '-' && roll > 0 && roll < 10
            @current_value = roll
            @total = roll unless @is_last
          end
      end
      
      def update_pending1(val)
        if @pending1 
          @pending11 = false
          @total += val
        end
      end
    def update_pending2(val)
      if @pending2
        @pending2 = false
        @total += val 
      end    
    end
    def evaluate_roll(roll, prev_roll)
      rules = ["handle_strike", "handle_spare", "handle_gutter", "handle_others"]  
      rules.each do |rule|
        if rule == "handle_spare"
            self.send(rule, [roll, prev_roll])
        else  
            self.send(rule, roll)
        end 
      end
    end     
end

class Game
    def initialize(frames)
        @frames = frames
        @scores = Array.new()
        @total_score = 0
    end

    def initialize_obj
        score = Score.new()
    end

    def calculate_scores()
        @frames.each.with_index do | frame, ind|
            is_last = ind == (@frames.length - 1) ? true : false   
            frame.each do |roll|
              score = Score.new(is_last)
              prev_value = @scores.length == 0 ? 0 : @scores.last.current_value 
              score.evaluate_roll(roll, prev_value)  
              current_value = score.current_value 
              @scores.last.update_pending1(current_value) if @scores.length > 0     
              @scores[-2].update_pending2(current_value) if @scores.length > 1 
              @scores << score 
            end
        end
    end

    def calculate_total
       calculate_scores 
       @scores.each{|s| p s}
       @total_score = @scores.inject(0){|acc, el| acc + el.total}
       @total_score
    end
    
end

frames = [ ['X'], [7, '/'], [9, '-'],['X'],['-', 8],[8, '/'],['-', 6], ['X'],['X'], ['X', 8, 1] ]
g = Game.new(frames)
p g.calculate_total()