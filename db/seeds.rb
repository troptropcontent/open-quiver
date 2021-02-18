# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'open-uri'
require 'nokogiri'
require 'faker'

puts " SEEDING ...................."

def scrap_board_from_akewatu(start_page, end_page)

  url = "https://www.akewatu.fr/surf/planches-de-surf?topProduct=0&pricerange=119%3B2000&zone%5B%5D=#{start_page}&page=#{end_page}"
  html_file = open(url).read
  html_doc = Nokogiri::HTML(html_file)
  cards = html_doc.search('.catalog__result__cart-item')
  boards = []
  cards.each do |card|
    title = card.search('.title.u-m-t-10.u-p-l-10.u-p-r-10')
    spec = card.search('.specs.u-m-t-10')
    image = card.search('.js-slider__ div')
    # [/https.*?jpeg/]
    if title.count == 1 && spec.count == 1
      url = "https://www.akewatu.fr#{card.search('a').attribute('href').text}"
      html_file = open(url).read
      html_doc = Nokogiri::HTML(html_file)
      board_category = html_doc.search('.u-w-5of12-at-md').search('dl').search('dd')[0].text.strip
      boards << {
      name: title[0].text.strip,
      length: spec.search('span')[0].text.strip,
      width: spec.search('span')[1].text.strip[1..-1],
      thickness: spec.search('span')[2].text.strip[1..-1],
      volume: spec.search('span')[3].text.strip,
      image: image.attribute('style').text.match(/https.*.+?(?=')/)[0],
      category: board_category.downcase,
      }
      # puts title[0].text.strip
      # puts "length: #{spec.search('span')[0].text.strip}"
      # puts "width: #{spec.search('span')[1].text.strip[1..-1]}"
      # puts "thickness: #{spec.search('span')[2].text.strip[1..-1]}"
      # puts "volume: #{spec.search('span')[3].text.strip}"
      # puts "image_url: #{image}"
      # puts "*********************************************"
    end
  end
  return boards
end

# to create new user
# user = User.new
# user.email = 'test@example.com'
# user.password = 'valid_password'
# user.password_confirmation = 'valid_password'
# user.save!

# spot de surf



def random_spot
  file      = File.open("#{pwd}/db/CARTE SPOTS SURF & SUP FRANCE.xml")
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
boards = scrap_board_from_akewatu(1, 2).first(10)
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
  category: board[:category],
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
  # photo_uri = URI.open('https://api.unsplash.com/search/photos?query=face')
  photo_uri = URI.open('https://images.unsplash.com/photo-1613507346182-fc34a2ca11a5?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&h=900&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1600')
  user.photo.attach(io: photo_uri, filename: "#{user.last_name}.png", content_type: 'image/png')
  user.save!
  new_board.user = user
  new_board.save!
end
  # ajouter un spot de surf au hasard
# pour chaque planche creer un user
  # sauvegarder l'user
  #  sauvegarder la planche
  puts "Done SEEDING"

  #https://source.unsplash.com/1600x900/?face
  