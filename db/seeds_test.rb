
require 'open-uri'
require 'nokogiri'

 url = "https://www.akewatu.fr/surf/planches-de-surf?topProduct=0&pricerange=119%3B2000&zone%5B%5D=1&page=4"
 html_file = open(url).read
 html_doc = Nokogiri::HTML(html_file)
 cards = html_doc.search('.catalog__result__cart-item')
 cards.each do |card| 
  title = card.search('.title.u-m-t-10.u-p-l-10.u-p-r-10')
  spec = card.search('.specs.u-m-t-10')
  image = card.at("//div[@itemprop = 'image']").attribute('style').value.match(/https.*?jpeg/)
  # [/https.*?jpeg/]
  if title.count == 1 && spec.count == 1
    puts title[0].text.strip
    puts "length: #{spec.search('span')[0].text.strip}"
    puts "width: #{spec.search('span')[1].text.strip[1..-1]}"
    puts "thickness: #{spec.search('span')[2].text.strip[1..-1]}"
    puts "volume: #{spec.search('span')[3].text.strip}"
    puts "image_url: #{image}"
    puts "*********************************************"
  end

end

# to create new user 
# user = User.new
# user.email = 'test@example.com'
# user.password = 'valid_password'
# user.password_confirmation = 'valid_password'
# user.save!


