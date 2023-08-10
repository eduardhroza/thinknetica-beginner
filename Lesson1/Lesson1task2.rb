#This programm calculates area of the triangle

puts "Hello there! I will be happy to calculate the area of the triangle for you. Please tell me the triangle base (a):"
a = gets.chomp.to_f

if a != 0.0
    puts "What is the height (h) of the triangle?"
  h = gets.chomp.to_f

  if h != 0.0
    s = (a * h) / 2

    puts "Area of the current triangle is #{s.to_f}." 
  else
    puts "Invalid input for height. Please enter a valid number."
  end
else
  puts "Invalid input for base. Please enter a valid number."
end