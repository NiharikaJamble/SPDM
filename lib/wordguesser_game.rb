class WordGuesserGame
  attr_accessor :word, :correct_guesses, :wrong_guesses

  def initialize(word)
    @word = word.downcase
    @correct_guesses = ''
    @wrong_guesses = ''
  end

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start do |http|
      return http.post(uri, "").body
    end
  end

  def guess(letter)
    raise ArgumentError.new("Not a valid letter") if letter.nil? || letter.empty? || !letter.match?(/[A-Za-z]/)

    letter = letter.downcase

    return false if @correct_guesses.include?(letter) || @wrong_guesses.include?(letter)

    if @word.include?(letter)
      @correct_guesses += letter
      true
    else
      @wrong_guesses += letter
      true
    end
  end

  def guesses
    @correct_guesses
  end

  def word_with_guesses
    @word.chars.map { |char| @correct_guesses.include?(char) ? char : '-' }.join
  end

  def check_win_or_lose
    return :lose if @wrong_guesses.length >= 7
    return :win if word_with_guesses == @word
    :play
  end
end
