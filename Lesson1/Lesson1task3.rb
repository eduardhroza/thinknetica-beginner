#This programm defines the type of the triangle

puts "Hello there! I will help you determine the type of triangle. Please enter the lengths of the three sides:"

a = gets.chomp.to_f
b = gets.chomp.to_f
c = gets.chomp.to_f

if a > 0 && b > 0 && c > 0
  if a == b && b == c
    puts "This is an equilateral triangle."
  elsif a**2 + b**2 == c**2 || a**2 + c**2 == b**2 || b**2 + c**2 == a**2
    puts "This is a right triangle."
  elsif a == b || a == c || b == c
    puts "This is an isosceles triangle."
  else
    puts "This is a scalene triangle."
  end
else
  puts "Invalid input. Please enter valid positive numbers for the sides of the triangle."
end