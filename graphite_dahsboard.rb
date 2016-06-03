#!/usr/local/bin/ruby

require 'http'
require 'json'
require 'net/http'

uri = URI("http://graphite.source.com/dashboard/find/?query=")
response = Net::HTTP.get(uri)
board_names = JSON.parse(response)['dashboards'].map{|n|n['name']}

board_names.map do |b|
	b = b.to_s.gsub(' ', '%20')
	b = b.to_s.gsub('>', '%3E')
	uri = URI("http://graphite.destination.com/dashboard/load/#{b}")
	dat = Net::HTTP.get(uri).to_s
	if dat["error"]
		print "#{b}"
                b = b.to_s.gsub(' ', '%20')
                b = b.to_s.gsub('>', '%3E')
                uri = URI("http://graphite.source.com/dashboard/load/#{b}")
                dat = Net::HTTP.get(uri).to_s
                state_str=JSON.parse(dat)['state'].to_json
                uri = URI("http://graphite.destination.com/dashboard/save/#{b}")
                Net::HTTP.post_form(uri, 'state' => state_str)
	else
	end
end
