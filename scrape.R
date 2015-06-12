#In this script we will scrape google queries
# source: http://www.r-bloggers.com/web-scraping-google-urls/

# load packages
library(RCurl)
library(XML)

get_google_page_urls <- function(u) {
  # read in page contents
  html <- getURL(u)
  
  # parse HTML into tree structure
  doc <- htmlParse(html)
  
  # extract url nodes using XPath. Originally I had used "//a[@href][@class='l']" until the google code change.
  attrs <- xpathApply(doc, "//h3//a[@href]", xmlAttrs)
  
  # extract urls
  links <- sapply(attrs, function(x) x[[1]])
  
  # free doc from memory
  free(doc)
  
  # ensure urls start with "http" to avoid google references to the search page
  links <- grep("http://", links, fixed = TRUE, value=TRUE)
  return(links)
}

u <- "http://www.google.com/search?aq=f&gcx=w&sourceid=chrome&ie=UTF-8&q=anthony+davis+scouting+report"
get_google_page_urls(u)

# At this point we have the top 9 search terms in links
# We now want to scrape each term in links
