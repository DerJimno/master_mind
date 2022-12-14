class Matsermind
  attr_reader :board, :feedback, :chosen_code

  def initialize 
    @win_comb = [1, 6, 2, 4] # example
    @feedback = []
    @board = [0, 0, 0, 0]
    @included = []
    @existing = []
  end

  def update_board(code)
    @board = code
  end

  def win?
    @win_comb == @board
  end

  def feedback
    board.each_with_index do |number, index|
      @win_comb.each_with_index do |duplicate, index1|
        if number == duplicate && index == index1
          @feedback += ["*"]
          if @input == "m" 
            @included += [duplicate]
          end
        elsif number == duplicate && index != index1
          @feedback += ["~"]
          if @input == "m" 
            @included += [duplicate]
          end
        end
        
      end
    end
    puts "Feedback: #{@feedback.shuffle}"
  end

  def conditioned?
    @chosen_code.uniq.length == 4 && @chosen_code.length == 4 && @chosen_code.all? { |el| el.between?(1, 6)}
  end

  def your_turn
    update_board(human_input)
    feedback
  end

  def cpu_turn
    update_board(cpu_input)
    feedback
  end

  def human_input
    input = gets.chomp
    @chosen_code = input.split(" ").map(&:to_i)
    conditioned?
    until conditioned?
      puts "----Invalid input----"
      human_input
    end
    @chosen_code
  end    

  def cpu_input
    rand_input = []
    
     until rand_input.uniq.length == 4 do
      if @included.uniq.length == 4
        rand_input += @included.uniq
        rand_input += rand_input.shuffle!

        until !@existing.include? rand_input.uniq do
          rand_input += rand_input.shuffle!
        end
        @existing += [rand_input.uniq]
      else
        rand_input += @included.uniq
        rand_number = Array.new(1, rand(1..6))
        until !rand_input.include? rand_number[0] do
          rand_number = Array.new(1, rand(1..6))
        end
        rand_input += rand_number
      end
    end
    if @input == "m"
      p rand_input.uniq
    end
    rand_input.uniq
  end

  def setup_turns
    until @input == "m" || @input == "c" do
      puts "Would you like to be the Mastermind or the Code-breaker? (M or C):"
      @input = gets.chomp.downcase
    end
    if @input == "m"
      puts "As a Mastermind, input your secret Code"
      puts "Hint: 4 different numbers (1-6) separated by 'space'"
      @win_comb = human_input
    elsif @input == "c"
      puts "Cpu is making secret code..."
      sleep(2)
      @win_comb = cpu_input
    end
  end

  def play
    puts "Welcome to Mastermind"
    print "----------------"
    print "----------------"
    print "--{"
    print " Rules "
    print "}------------" 
    print "----------------"
    print "---------""\n"
    puts "1- You can play against the Cpu, remember: Humans are superior to computers "
    puts "2- There are 6 possibilities in which only 4/6 numbers can occur(No Duplicates)"
    puts "3- In feedback (*) means the player guessed one right number in it's right position"
    puts "4- (~) means player got one right number but misplaced it"
    puts "5- The feedback elements aren't sorted in proper order, Good-Luck ;)"
    print "----------------"
    print "----------------"
    print "----------------"
    print "----------------"
    print "----------------" "\n"
    setup_turns
    if @input == "c"
      puts "Okay, Try 4 different numbers (1-6) separated by 'space'"
      12.times do 
        your_turn
        @feedback = []
        if win? 
          puts "Code-breaker wins"
          break
        end
        puts "Keep going, til' you guess it right"
      end
      puts"Game Over"

    elsif @input == "m" 
      12.times do
        puts "Cpu is thinking..."
        sleep(2)
        cpu_turn
        @feedback = []
        
        if win?
          puts "Mastermind lost"
          break
        end
      end
      puts"Game Over"
    end
  end
end
game = Matsermind.new
game.play