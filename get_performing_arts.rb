require 'nokogiri'
require 'open-uri'
require 'json'

domain = "http://perform.susu.org"
societies = []

index = Nokogiri::HTML(open("#{domain}/societies.php"))
index.xpath("//a[text()='Read More']/@href").each do |society_link|
    society = Nokogiri::HTML(open("#{domain}/#{society_link}"))

    name = society.xpath("//h1/text()").first.to_s
    sub_name = society.xpath("//h2/text()").first.to_s
    if sub_name && sub_name.length != 0
        name = "#{name} - #{sub_name}"
    end
    description = society.xpath("//div[@class='span8']//text()").map(&:to_s).join('\n')

    social_links = {}
    society.xpath("//table//a[img]/@href").each do |link|
        link = link.to_s
        if link.include?('twitter.com')
            social_links[:twitter] = link
        elsif link.include?('facebook.com') || link.include?('fb.com')
            social_links[:facebook] = link
        else
            social_links[:website] = link
        end
    end

    societies << {
        name: name,
        description: description,
        links: social_links,
    }
end

File.open('performing_arts.json', 'w') do |f|
    JSON.dump(societies, f)
end