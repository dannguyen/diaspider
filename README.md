# Diaspider

**Diaspider** stands for *"Diaspider is another spider"* or, more accurately, *"Damn it, another spider"*.

## Why another web crawling library?

It takes parts that I like from [joeyAghion/spidey](https://github.com/joeyAghion/spidey) and [propublica/upton](https://github.com/propublica/upton) and does a disservice to them, all the while adding conveniences particular to my needs but unlikely to be good design decisions.

Web-scraping is a very common and vital and ordinary task, unfortunately, it encompasses a wide range of assumptions about data and categorization. Therefore, the need for different custom approaches.

Like [spidey](https://github.com/joeyAghion/spidey), __diaspider__ relies a lot on the wonderful [Mechanize](http://mechanize.rubyforge.org/) and [Nokogiri](http://nokogiri.org/) libraries, which do pretty much all of what constitutes the crawling and parsing of information on the Web.

What I hope to do is try to create a YAML-based convention to define the navigation of the crawlers and the structure of the data that they bring back. I'm almost sure that this is *not* a proper use of YAML, but it seems slightly cleaner than defining boilerplate crawler behavior inside Ruby script files. Only one way to find out!




