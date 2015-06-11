require! fs
data = fs.readFileSync "#__dirname/../data/vyhosteni.tsv" .toString!split "\n"
  ..pop!
  ..shift!

countries_assoc = {}
for datum in data
  [country, count, year] = datum.split "\t"
  countries_assoc[country] ?= [0,0,0,0,0]
  year = parseInt year, 10
  count = parseInt count, 10
  year -= 2010
  countries_assoc[country][year] = count
out = for country, values of countries_assoc
  ([country] ++ values).join "\t"
out.unshift "country\t2010\t2011\t2012\t2013\t2014"
fs.writeFileSync "#__dirname/../data/vyhosteni_countries.tsv", out.join "\n"
