#!/usr/bin/env ruby

require 'sinatra'
require 'geoip'
require 'json'


set :server, ["thin"]
set :db_location, "db/GeoLiteCity.dat" # Point this to your GeoIp database in binary form (aka .dat)
set :require_secret_key, false         # If true, initialize secret_key
set :secret_key, ""                    # Initialize with your own if you want requests to be authenticated

if not File.exists?(settings.db_location)
  puts <<EOM
#################################
###          WARNING          ###
#################################

Unable to find GeoLiteCity Database at #{settings.db_location}
You can retrive it from http://dev.maxmind.com/geoip/geolite
Download either City/Country Database in Binary Format"
EOM
  exit -1
end

if settings.require_secret_key && (settings.secret_key.length == 0)
  puts <<EOM
#################################
###          WARNING          ###
#################################

You require the secret key but didn't provided any.
Either add your custom secret key or disable it!
EOM
  exit -1
end

GEOIP = GeoIP.new(settings.db_location)

def authenticate!
  params.has_key?("auth") && params["auth"] == settings.secret_key
end

get "/" do
  return [401, {"Content-Type" => "application/json"}, {error: "Unauthorized access.", code: "-1"}.to_json] if settings.require_secret_key && !authenticate!

  q = params["q"] || request.ip
  result = GEOIP.city(q)
  if result.nil?
    [400, {"Content-Type" => "application/json"}, {error: "Unable to find information for ip: #{q}", code: "-2"}.to_json]
  else
    [200, {"Content-Type" => "application/json"}, GEOIP.city(q).to_hash.to_json]
  end
end
