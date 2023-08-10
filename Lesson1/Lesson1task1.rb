#This programm calculates your perfect weight

puts "Hello there! I will be happy to tell your perfect weight. What is your name?"
name = gets.chomp

puts "What is your height, #{name}?"
height = gets.chomp.to_f

# Check if inserted user data is correct
if height != 0.0
    perfectweight = (height - 110.0) * 1.15
    puts "So #{name}, your perfect weight is #{perfectweight}."
else
    puts "Invalid input for height. Please enter a valid number."
end
