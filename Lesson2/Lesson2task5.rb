# Lesson 2 task 5

# Заданы три числа, которые обозначают число, месяц, год (запрашиваем у пользователя). 
# Найти порядковый номер даты, начиная отсчет с начала года. 
# Учесть, что год может быть високосным. Запрещено использовать встроенные в ruby 
# методы для этого вроде Date#yday или Date#leap?).

puts "Day:"
day = gets.chomp.to_i

puts "Month:"
month = gets.chomp.to_i

puts "Year:"
year = gets.chomp.to_i

leap_year = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)

days_in_month = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
days_in_month[1] = 29 if leap_year

ordinal_day = day + days_in_month.take(month - 1).sum

puts "Date sequence number: #{ordinal_day}"