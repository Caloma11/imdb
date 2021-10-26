require './scraper'
require 'yaml'

urls = fetch_urls

movies = []

urls.each do |url|
  movies << scrape_movie(url)
end


File.open("movies.yml", "w") do |file|
   file.write(movies.to_yaml)
end
