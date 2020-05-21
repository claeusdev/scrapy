require "httparty"
require "nokogiri"
require "byebug"


def scrapper
  url = "https://www.indeed.com/jobs?q=junior+developer&l="
  unparsed_page = HTTParty.get(url)
  parsed_page = Nokogiri::HTML(unparsed_page)
  all_jobs = []
  jobs = parsed_page.css("div.result")

  page = 0
  per_page = jobs.count
  total = parsed_page.css("div#searchCountPages").text.split(" ")[3].gsub(",", "").to_i

  last_page = (total.to_f/per_page.to_f).round
  p total
  p per_page
  p "Last page"
  while page <= last_page
    pagination_url = "https://www.indeed.com/jobs?q=junior&start=#{page}"
   paginated_unparsed_page = HTTParty.get(pagination_url)
  paginated_parsed_page = Nokogiri::HTML(paginated_unparsed_page)
  paginated_jobs = paginated_parsed_page.css("div.result")

  p "Page #{page}"
   paginated_jobs.each do |listing|
      job = {
        title: listing.css("h2.title").text,
        company: listing.css("span.company").text,
        location: listing.css("span.location").text,
        url: "https://www.indeed.com/" + listing.css("a")[0].attributes["href"].value
      }
      all_jobs << job
    end

    page += 10
  end
  byebug
end


scrapper
