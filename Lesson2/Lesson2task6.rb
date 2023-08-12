=begin
Lesson 2 task 5
Сумма покупок. Пользователь вводит поочередно название товара, цену за единицу и 
кол-во купленного товара (может быть нецелым числом). Пользователь может ввести 
произвольное кол-во товаров до тех пор, пока не введет "стоп" в качестве названия товара.
На основе введенных данных требуетеся:
Заполнить и вывести на экран хеш, ключами которого являются названия товаров, 
а значением - вложенный хеш, содержащий цену за единицу товара и кол-во купленного товара. 
Также вывести итоговую сумму за каждый товар.
Вычислить и вывести на экран итоговую сумму всех покупок в "корзине".
=end

products = {}

loop do
  puts "Enter product name (or 'stop' to finish):"
  name = gets.chomp
  
  break if name == "stop"
  
  puts "Enter price per unit:"
  price = gets.chomp.to_f
  
  puts "Enter quantity purchased:"
  quantity = gets.chomp.to_f
  
  # Create a nested hash with price and quantity
  product_details = {
    "Price per unit" => price,
    "Quantity" => quantity
  }
  
  # Add the product and its details to the product hash
  products[name] = product_details
end

# Display a populated hash with items and their details
puts "Products and details:"
products.each do |product, details|
  puts "Product: #{product}"
  details.each do |key, value|
    puts "#{key}: #{value}"
  end
  puts "-" * 20
  puts "-" * 20
  puts "-" * 20
end

# Total for each item
puts "Total for each item:"
products.each do |product, details|
  puts "Product: #{product}"
  price_per_unit = details["Price per unit"]
  quantity = details["Quantity"]
  total_price = price_per_unit * quantity
  
  puts "Price per unit: #{price_per_unit}"
  puts "Quantity: #{quantity}"
  puts "Total price: #{total_price}"
  
  puts "-" * 20
  puts "-" * 20
  puts "-" * 20
end

# Total purchases in the basket
total_purchase = 0
products.each do |product, details|
  price_per_unit = details["Price per unit"]
  quantity = details["Quantity"]
  total_price = price_per_unit * quantity
  total_purchase += total_price
end

puts "Total purchases in the basket: #{total_purchase}"

