=begin 
The program calculates the discriminant and roots of a quadratic equation 
with given coefficients a, b and c, then displays the obtained values on the screen.
=end

puts "Hello mr. Who, give me 3 numbers"

a = gets.chomp.to_f
b = gets.chomp.to_f
c = gets.chomp.to_f

#Discriminant calculation
d = (b**2)-(4.0*a*c)

if d > 0
  #Roots of discriminant calculation
  x1 = (-b + Math.sqrt(d))/(2*a)
  x2 = (-b - Math.sqrt(d))/(2*a)
  puts "Your discriminant is #{d}, x1 = #{x1}, x2 = #{x2}"
 elsif d < 0
  puts "No roots, your discriminant is #{d}"
 elsif d == 0 
  puts "Roots are equal and = #{x1}, your discriminant is = #{d}"
end