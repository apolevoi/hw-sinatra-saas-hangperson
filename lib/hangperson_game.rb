class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.
  attr_accessor :word, :guesses, :wrong_guesses

  # Get a word from remote "random word" service
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end
  
  #Process a guess and modify the instance variables wrong_guesses and guesses accordingly
  def guess(char)
    
    #Check if letter guessed is nil or empty or not a letter and throw error
    if char.nil? || char == "" || char !~ /[[:alpha:]]/
      raise ArgumentError
    end
    
    #Convert character to downcase to make it case insensitive.
    #Check if letter has already been guessed in correct or wrong guess buckets
    char = char.downcase
    if @guesses.include? char 
      return false
    elsif @wrong_guesses.include? char
      return false
    end
    
    #Check if word contains letter. If yes, increment guesses by 1. If not, increment wrong guesses by 1.
    if @word.include? char
      @guesses += char
      return true
    else
      @wrong_guesses += char
      return true
    end

  end
  
  #Build together the word with succesful guesses
  def word_with_guesses
	  @word.gsub(/[^ #{@guesses}]/, '-')
  end
  
  #Check whether wrong guesses is 7 or more - If so, game over. If word is guessed
  #in under 7 guesses, you win! If not, keep playing. 
  def check_win_or_lose
    
    if word_with_guesses == @word
      return :win
    elsif @wrong_guesses.length >= 7 
      return :lose
    else  
      return :play
    end
  
  end   
      

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

end
