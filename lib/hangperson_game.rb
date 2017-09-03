class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.
  attr_accessor :word, :guesses, :wrong_guesses

  # Get a word from remote "random word" service

  # def initialize()
  # end
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end
  
  #guess, which processes a guess and modifies the instance variables wrong_guesses and guesses accordingly

  def guess(char)
    
    #Check if letter guessed is nil or empty or not a letter and throw error
    if char.nil? || char == "" || char =~ /[^A-Za-z]/
      raise ArgumentError
    end
    
    #Why doesn't it work with !!?
    #Check if letter has already been guessed in correct or wrong guess buckets
    if @guesses.upcase.include? char.upcase or @wrong_guesses.upcase.include? char.upcase
      return false
    end
    
    #Check if word contains letter. If yes, incremenet guesses by 1. If not, increment wrong guesses by 1.
    if @word.include? char
      @guesses += char
    else
      @wrong_guesses += char
    end

  end
  
  #Build together the word with succesful guesses
  def word_with_guesses
	  @word.gsub(/[^ #{@guesses}]/, '-')
  end
  
  #Check whether wrong guesses is 7 or more, which means game over. If word is guessed
  #in under 7 guesses, you win! If not, keep playing. 
  def check_win_or_lose
    
    if @wrong_guesses.length >= 7
      return :lose
    end
    
    if word_with_guesses == @word
      return :win
    end
    
    :play
    
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
