RubyGeoIp
=========

RubyGeoIp is a _very_ simple webservice build to server GepIp data.

It's a (again, _very very_) simple sinatra application which replies to (eventually authenticated) ip-geolocation requests with data from GeoIp Database.

GeoIp Database are provided by [MaxMind](http://www.maxmind.com/en/home).

Good Guy MaxMind offers free GeoIp Database, known as [GeoLite](http://dev.maxmind.com/geoip/geolite) and also more accurate non-free version you can find [here](http://www.maxmind.com/en/geolocation_landing)

For use with this project, rembember to download the .dat version of the database. To interface with that db this project used [geoip](http://geoip.rubyforge.org/) gem.

Configuration
-------------

Run bundle to install the gem needed, as now only three are needed:
 * sinatra
 * geoip
 * json



In `ruby_geo_ip.rb` you will find 3 configuration settings:
```ruby
# This needs to point to the GeoIp database, in .dat format
set :db_location, "db/GeoLiteCity.dat"
# Specify if an authentication is needed or not
set :require_secret_key, true
# Set the secret key
set :secret_key, "" # INITIALIZE WITH YOUR OWN
```

If you don't want your service to be accessible from anyone but you, add a secure secret_key in the configuration, and append it to the requests as `auth` param.


Run
---

In development:

Simply launch `./ruby_geo_ip.rb`, it will start a Sinatra app (on port 4567 by default).

*Production:*
Some tips about configuration in production will be added. But it's just a sinatra app :)

Usage
-----

This _damn simple_ software just expose the root path to direct request, e.g.:

`http://localhost:4567/?q=64.71.22.18`

will return
```json
{
  "request"=>"64.71.22.18",
  "ip"=>"64.71.22.18",
  "country_code2"=>"US",
  "country_code3"=>"USA",
  "country_name"=>"United States",
  "continent_code"=>"NA",
  "region_name"=>"CA",
  "city_name"=>"Santa Clara",
  "postal_code"=>"95054",
  "latitude"=>37.39609999999999,
  "longitude"=>-121.96170000000001,
  "dma_code"=>807,
  "area_code"=>408,
  "timezone"=>"America/Los_Angeles"
}
```




