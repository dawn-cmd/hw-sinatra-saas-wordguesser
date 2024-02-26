class WordGuesserGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    @masked_word = '-' * @word.length
  end

  def guess(letter)
    raise ArgumentError if invalid_letter?(letter)

    letter.downcase!

    return handle_wrong_guess(letter) unless word_contains_letter?(letter)

    update_guesses(letter)
    update_masked_word(letter)
  end

  def show
    return :win if @word == '-' * @word.length

    return :lose if @wrong_guesses.length >= 7

    :play
  end
  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word

  def self.random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start do |http|
      return http.post(uri, '').body
    end
  end

  private

  def invalid_letter?(letter)
    letter.nil? || letter.empty? || letter.match(/[^a-zA-Z]/)
  end

  def word_contains_letter?(letter)
    @word.include?(letter)
  end

  def handle_wrong_guess(letter)
    @wrong_guesses << letter
    true
  end

  def update_guesses(letter)
    @guesses << letter
  end

  def update_masked_word(letter)
    @word.each_char.with_index do |c, i|
      @masked_word[i] = c if c == letter
      @word[i] = '-'
    end
  end
end
