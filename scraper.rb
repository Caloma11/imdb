require 'open-uri'
require 'nokogiri'

def fetch_urls
  url = "https://www.imdb.com/chart/top"

  html_file = URI.open(url).read
  html_doc = Nokogiri::HTML(html_file)

  urls = []

  html_doc.search('.titleColumn a').each do |element|
    urls << "https://www.imdb.com" + element.attributes["href"].value
  end

  return urls[0..4]
end

def scrape_movie(url)
  html_file = URI.open(url).read
  html_doc = Nokogiri::HTML(html_file)

  movie_title = html_doc.search('h1').first.text
  movie_desc = html_doc.search(".GenresAndPlot__TextContainerBreakpointXS_TO_M-cum89p-0").first.text
  director = html_doc.search('.ipc-metadata-list__item:contains("Director") a').first.text
  year = html_doc.search('a.ipc-link.ipc-link--baseAlt.ipc-link--inherit-color.TitleBlockMetaData__StyledTextLink-sc-12ein40-1.rgaOW').first.text

  stars = []
  html_doc.search('.ipc-metadata-list__item.ipc-metadata-list-item--link:contains("Stars") a').each do |item|
    if item.text != "Stars" && item.text != ""
      stars << item.text
    end
  end

  movie = {
    title: movie_title,
    description: movie_desc,
    director: director,
    year: year,
    cast: stars.uniq
  }

  return movie

end
