# Lesson 2 task 4
# Заполнить хеш гласными буквами, 
# где значением будет являтся порядковый номер буквы в алфавите (a - 1).

Hash1 = ('a'..'z').to_a.each_with_index.to_h { |letter, index| [letter, index + 1] }
puts Hash1