require "json"
require "open-uri"
 
class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @result = ""

     # Get the user input and random letters as arrays of characters
    user_input = params[:longest_word].downcase.chars
    array_letters = params[:letters].downcase.chars

     # Use tally to count occurrences of each letter in both arrays
    # tally creates a hash where:
    # - the key is a letter
    # - the value is the number of times the letter appears
    user_input_hash = user_input.tally
    array_letters_hash = array_letters.tally
    
    # Check if each letter in the user's input exists in the random letters array
    # and if it appears at least as many times as in the user's input
    user_input_hash.each do |letter, count|
    # If the letter doesn't exist or the count is insufficient, return an error message
      if array_letters_hash[letter].nil? || array_letters_hash[letter] < count
        @result = "Sorry but #{params[:longest_word]} can't be built out of the current array."
        return
      end
    end


    url = "https://dictionary.lewagon.com/#{params[:longest_word]}"
    word_serialized = URI.open(url).read
    word = JSON.parse(word_serialized)

    if word["found"] == false
      @result = "Sorry but #{params[:longest_word]} does not seem to be a valid english word"
      return
    else
      @result = "Congratulation! #{params[:longest_word]} is a valid English word!"
      return
    end
  end

end
