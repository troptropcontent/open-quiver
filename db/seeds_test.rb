require_relative '../app/models/board.rb'
require 'open-uri'
require 'nokogiri'
require 'faker'


def scrap_board_from_akewatu(start_page, end_page)

  url = "https://www.akewatu.fr/surf/planches-de-surf?topProduct=0&pricerange=119%3B2000&zone%5B%5D=#{start_page}&page=#{end_page}"
  # url = "https://www.akewatu.fr/surf/planches-de-surf?topProduct=0&pricerange=119%3B2000&zone%5B%5D=#{1}&page=#{2}"
  html_file = open(url).read
  html_doc = Nokogiri::HTML(html_file)
  cards = html_doc.search('.catalog__result__cart-item')
  boards = []
  cards.each do |card| 
    title = card.search('.title.u-m-t-10.u-p-l-10.u-p-r-10')
    spec = card.search('.specs.u-m-t-10')
    # image = card.at("//div[@itemprop = 'image']").attribute('style').value.match(/https.*?jpeg/)
    image = card.search('.js-slider__ div')

    # [/https.*?jpeg/]
    if title.count == 1 && spec.count == 1
      boards << {
      name: title[0].text.strip,
      length: spec.search('span')[0].text.strip,
      width: spec.search('span')[1].text.strip[1..-1],
      thickness: spec.search('span')[2].text.strip[1..-1],
      volume: spec.search('span')[3].text.strip,
      image: image.attribute('style').text.match(/https.*?jpeg/)[0]
      }
      # puts "length: #{spec.search('span')[0].text.strip}"
      # puts "width: #{spec.search('span')[1].text.strip[1..-1]}"
      # puts "thickness: #{spec.search('span')[2].text.strip[1..-1]}"
      # puts "volume: #{spec.search('span')[3].text.strip}"
      puts 
      # puts "*********************************************"
    end
  end
  # return boards
end

# to create new user 
# user = User.new
# user.email = 'test@example.com'
# user.password = 'valid_password'
# user.password_confirmation = 'valid_password'
# user.save!

# spot de surf
def random_spot
  file      = File.open('/home/tomecrepont/code/troptropcontent/open-quiver/db/CARTE SPOTS SURF & SUP FRANCE.xml')
  document  = Nokogiri::XML(file)
  spots = []
  spots_list = document.root.xpath('Placemark')
  spots_list.each do |spot| 
      loc = spot.xpath('Point').xpath('coordinates').text.strip.split(',').map{|num| num.to_f}
      spots << {
      name: spot.xpath('name').text.strip,
      latitude: loc[0],
      longitude: loc[1],
      }
  end
  return spots.sample 
end

def board_status
  rand <= 0.8 ? "active" : "deactivated"
end

def cloudinary(url)
  file = URI.open(url)
  new_board.photo.attach(io: file, filename: "#{Faker::Internet.password}.png", content_type: 'image/png')
end


# itere a travers la list de planche
boards = scrap_board_from_akewatu(1, 2)
boards.each do |board|
  spot = random_spot
  new_board = Board.new(
  name: board[:name],
  length: board[:length],
  width: board[:width],
  thickness: board[:thickness],
  volume: board[:volume],
  longitude: spot[:longitude],
  latitude: spot[:latitude],
  status: board_status,
  ) 
  file = URI.open(board[:image])
  new_board.photo.attach(io: file, filename: "#{Faker::Internet.password}.png", content_type: 'image/png')
  #  create a new user
  user = User.new
  user.first_name = Faker::Name.first_name
  user.last_name = Faker::Name.last_name 
  user.email = Faker::Internet.safe_email(name:"#{user.first_name.downcase}#{user.last_name.downcase}")
  user.password = Faker::Internet.password(min_length: 10, max_length: 20)
  user.password_confirmation = user.password
  user.save!
  new_board.user = user
  new_board.save!
end
  # ajouter un spot de surf au hasard
# pour chaque planche creer un user 
  # sauvegarder l'user
  #  sauvegarder la planche

  