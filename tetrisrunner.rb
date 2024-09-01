require_relative './hw5provided'
require_relative './hw5assignment'

def runTetris
  Tetris.new 
  mainLoop
end

def runMyTetris
  MyTetris.new
  mainLoop
end

def runMyTetrisChallenge
  MyTetrisChallenge.new
  mainLoop
end

if ARGV.count == 0
  runMyTetrisChallenge
elsif ARGV.count != 1
  puts "usage: hw5runner.rb [enhanced | original]"
elsif ARGV[0] == "enhanced"
  runMyTetris
elsif ARGV[0] == "original"
  runTetris
else
  puts "usage: hw5runner.rb [enhanced | original]"
end

