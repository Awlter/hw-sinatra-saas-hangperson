class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  attr_accessor :word, :guesses, :wrong_guesses
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
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

  def guess(letter)
    raise ArgumentError if letter.to_s =~ /(^$|[^\w\s]+)/i
    return false if (guesses + wrong_guesses) =~ /#{Regexp.escape letter}/i

    if word.include?(letter)
      guesses << letter
    else
      wrong_guesses << letter
    end
  end

  def word_with_guesses
    word.chars.each_with_object('') do |letter, result|
      result << (guesses.include?(letter) ? letter : '-')
    end
  end

  def check_win_or_lose
    return :lose if wrong_guesses.length >= 7
    word.chars.all? { |l| guesses.include? l} ? :win : :play
  end
end
