# require 'sinatra'
# require 'sinatra/base'
# require 'sinatra/flash'
# require_relative './lib/wordguesser_game.rb'


# class WordGuesserApp < Sinatra::Base

#   set :views, File.dirname(__FILE__) + '/views'

#   enable :sessions
#   register Sinatra::Flash
  
#   before do
#     @game = session[:game] || WordGuesserGame.new('')
#   end
  
#   after do
#     session[:game] = @game
#   end
  
#   get '/' do
#     puts "Rendering new game page"
#     redirect '/new'
#   end
  
#   get '/new' do
#     puts "Rendering new game page"
#     erb :new
#   end
  
#   post '/create' do
#     word = params[:word] || WordGuesserGame.get_random_word

#     @game = WordGuesserGame.new(word)
#     redirect '/show'
#   end
  

#   post '/guess' do
#     letter = params[:guess].to_s[0]
#     redirect '/show'
#   end
  
#   get '/show' do
#     erb :show 
#   end
  
#   get '/win' do
#     erb :win 
#   end
  
#   get '/lose' do
#     erb :lose
#   end
  
# end

require 'sinatra/base'
require 'sinatra/flash'
require_relative './lib/wordguesser_game.rb'

class WordGuesserApp < Sinatra::Base
  enable :sessions
  register Sinatra::Flash

  port = ENV['PORT'] || 8080
  

  before do
    @game = session[:game]   # Default word for testing
  end

  after do
    session[:game] = @game
  end

  get '/' do
    redirect '/new'
  end

  get '/new' do
    erb :new
  end

  post '/create' do
    word = WordGuesserGame.get_random_word 
    @game = WordGuesserGame.new(word)       
    redirect '/show'
  end

  post '/guess' do
    
    letter = params[:letter]
    
    # Validate letter input
    if letter.nil? || letter.empty? || letter.length != 1 || !letter.match?(/[A-Za-z]/)
      @error = "Please enter a single valid letter."
      erb :show # or whatever your main view is
    else
      result = @game.guess(letter)
      
      if result
        @message = "You guessed '#{letter}'."
      else
        @message = "You've already guessed '#{letter}'."
      end
      
      # Check for win/lose conditions
      game_status = @game.check_win_or_lose
      if game_status == :win
        @message = "Congratulations! You've won!"
      elsif game_status == :lose
        @message = "Sorry, you've lost! The word was '#{@game.word}'."
      end
  
      @game_status = @game.check_win_or_lose
      erb :show # Render the updated view
    end
  end

  get '/show' do
    @game_status = @game.check_win_or_lose
    erb :show
  end

  post '/try_again' do
    word = WordGuesserGame.get_random_word  # Get a new word
    @game = WordGuesserGame.new(word)        # Reinitialize the game with the new word
    @message = "New game started! Good luck!" # Optionally inform the user
    redirect 'show'  # Render the index view again
  end

  run! if app_file == $0
end



