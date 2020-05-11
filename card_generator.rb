class CardGenerator
  attr_reader :suits,
              :i,
              :royal,
              :numbers,
              :pecking_order,
              :style,
              :deck

  def initialize(i)
    @i = i #gets.chomp
    @suits = []
    @royal = ["Jack", "Queen", "King"]
    @numbers = str_arr
    @pecking_order = nil
    @style = nil
    @shuffled = false
    @deck = []
    start
    get_style
    get_integer
    shuffle_prompt # generates decks
    write_it ### how do you test this??
    print_msg
  end

  def write_it
    File.open("#{"shuffled_" if @shuffled}#{@style.downcase}_deck#{"s" if @i > 1}.txt", "w") do |file|
      @deck.each do |d_elem|
        file.puts("#{d_elem}".gsub(/[\[\]\"]/, ""))
      end
    end
  end

  def shuffle_prompt

    puts "Do you want to shuffle the cards?"
    puts "Continue? [Y]es / [N]o"
    invalid_counter = 3

    loop do

      p = gets.upcase.chomp

      if p == "Y"
        shuffle
        generate_deck
        break
      elsif p == "N"
        generate_deck
        break
      else
        puts "Invalid input. #{invalid_counter} attempts left."
        puts "Shuffle the cards? [Y]es / [N]o"
        invalid_counter -= 1
        if invalid_counter == 0
          puts "Goodbye"
          exit
        end
      end
    end

  end

  def print_msg
    puts "Generating #{cards_to_print} #{"shuffled" if shuffled?} cards in '#{"shuffled_" if @shuffled}#{@style.downcase}_deck#{"s" if @i > 1}.txt'"
    puts "...."
    puts "Success!"
  end

  def get_style
    puts "Pick a deck style: [S]tandard / [T]arot Minor Arcana"
    invalid_counter = 3

    loop do
      style = gets.upcase.chomp
      if style == "S"
        standardize
        break
      elsif style == "T"
        tarotize
        break
      else
        puts "Invalid input. #{invalid_counter} attempts remaining!"
        puts "Pick a deck style: [S]tandard / [T]arot Minor Arcana"
        invalid_counter -= 1
        if invalid_counter.zero?
          puts "Goodbye"
          exit
        end
      end
    end

  end

  def get_integer

    puts "This program can generate multiples of decks to play games longer"
    puts "Input an Integer number for how many you want (Whole number): "
    invalid_counter = 3

    loop do
      int = gets.chomp.to_i
      if int == 0
        puts "If you want none decks, you will get none!"
        puts "Goodbye!"
        exit
      elsif int.class == Integer && int.negative?
        puts "Why so negative? We're gonna turn that frown upside down!"
        @i = int * -1
        break
      elsif int.class == Integer && int.positive?
        @i = int
        break
      else
        puts "Invalid input. #{invalid_counter} attempts remaining!"
        puts "Input an Integer number (Whole number, without decimals): "
        invalid_counter -= 1
        if invalid_counter.zero?
          puts "Goodbye"
          exit
        end
      end
    end

  end

  def start

    puts "Hello. Let's build a deck of cards."
    puts "This program will generate a text file."
    puts "Continue? [Y]es / [N]o"
    invalid_counter = 3

    loop do
      p = gets.upcase.chomp
      if p == "Y"
        break
      elsif p == "N"
        puts "Goodbye"
        exit
      else
        puts "Invalid input. #{invalid_counter} attempts left. Continue? [Y]es / [N]o"
        invalid_counter -= 1
        if invalid_counter.zero?
          puts "Goodbye"
          exit
        end
      end
    end

  end

  def standardize
    @suits = standard_suits
    @pecking_order = standard_order
    @style = "Standardized"
  end

  def standard_suits
    [:club, :spade, :heart, :diamond]
  end

  def tarotize
    @suits = tarot_suits
    @royal.unshift "Knight"
    @pecking_order = tarot_order
    @style = "Tarotized"
  end

  def tarot_suits
    [:cup, :wand, :coin, :sword]
  end

  def aces_high?
    @suits == standard_suits
  end

  def ace
    ["Ace"]
  end

  def str_arr
    (2..10).to_a.map { |num| num.to_s }
  end

  def standard_order
    [numbers, royal, ace].flatten!
  end

  def tarot_order
    [ace, numbers, royal].flatten!
  end

  def deck_size
    @pecking_order.size * @suits.size
  end

  def cards_to_print
    @i * deck_size
  end

  def shuffled?
    @shuffled
  end

  def generate_deck
    d_arr = Array.new

    n = 2 if style == "Standardized"
    n = 1 if style == "Tarotized"

    @i.times do
      suits.each do |suit|
        pecking_order.each.with_index(n) do |peck, n|
          d_arr << [peck, suit.capitalize.to_s, n.to_s]
        end
      end
    end

    d_arr.shuffle! if shuffled?

    @deck = d_arr
  end

  def shuffle
    @shuffled = true
  end

end

# num arg was for writing tests
# since it is re-assinged don't worry
CardGenerator.new(0)
