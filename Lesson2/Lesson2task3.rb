# Lesson 2 task 3
#Заполнить массив числами фибоначчи до 100

fibonnacci = 0

arr = [0, 1]

loop do
  fibonacci = arr[-1] + arr[-2]
  break if fibonacci > 100

  arr << fibonacci
end

puts arr