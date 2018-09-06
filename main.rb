require "net/http"


def fetch(uri, query, limit = 10)
    uri_parsed = URI(uri)
    uri_parsed.query = URI.encode_www_form(query) if query
    response_uri = Net::HTTP.get_response(uri_parsed)

    case response_uri
    when Net::HTTPRedirection then
        redirect_location = response_uri["location"]
        puts "Redirection to #{redirect_location}"
        fetch(redirect_location, nil, limit - 1)
    when Net::HTTPSuccess then
        puts "Saving file..."
        result = response_uri.body
        file = File.open("index.html", "w") do |file_instance|
            file_instance.puts result
        end
        puts "Saved!"
    else
        puts "Not found!"
    end
end


term = gets.chomp
page_uri = "https://en.wikipedia.org/w/index.php"
query = { search: term }
fetch(page_uri, query)

