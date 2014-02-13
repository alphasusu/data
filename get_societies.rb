require 'json'
require 'nokogiri'
require 'open-uri'

group_list = "http://www.susu.org/php/ajax-browser?zone=0"
def group_details(id)
    "http://www.susu.org/php/ajax-browser?group=#{id}"
end

societies = []

societies_data = Nokogiri::HTML(open(group_list))
societies_data.xpath("//li").each_with_index do |society_node, i|
    logo = society_node.xpath("div/img[@class='grouplogo']/@src").to_s
    name = society_node.xpath("p/text()").to_s.strip
    zone = society_node.xpath("@class").to_s.gsub('zone_', '').gsub('groupselect', '').strip.to_i

    id = society_node.xpath("@id").to_s.gsub('group_', '').to_s
    society_data = Nokogiri::HTML(open(group_details(id)))

    description = society_data.xpath("//p[not(img) and not(a)]/text()").first.to_s
    website = society_data.xpath("//img[@title='Website']/../@href").first.to_s
    twitter = society_data.xpath("//img[@title='Twitter']/../@href").first.to_s
    facebook = society_data.xpath("//img[@title='Facebook']/../@href").first.to_s
    email = society_data.xpath("//img[@title='Email']/../@href").first.to_s.gsub('mailto:', '')
    type = society_data.xpath("//*[@class='groupkind']/text()").first.to_s

    societies << {
        name: name,
        logo: logo,
        zone: zone,
        description: description,
        website: website,
        twitter: twitter,
        facebook: facebook,
        email: email,
        type: type,
    }

    puts "#{name} - Type: #{type}, Zone: #{zone}"
end

File.open('societies.json', 'w') do |f|
    JSON.dump(societies, f)
end