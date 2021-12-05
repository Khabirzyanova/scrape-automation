library(tidyverse)
library(rvest)
library(janitor)

# MICEX - Top Gainers
url <- "https://markets.businessinsider.com/index/market-movers/micex"

# extract html 
url_html <- read_html(url)

#table extraction
url_tables <- url_html %>% html_table(fill = TRUE)

#extract relevant table
top_gainers <- url_tables[[1]]

#extract relevant columns
top_gainers %>%
  select(1:4) -> top_gainers

# change names 
top_gainers %>% 
  clean_names() -> top_gainers

# get percent gain
percent_gain <- substring(str_split_fixed(top_gainers$percent, '\\.', 2)[,2], first=3)


# new table with relevant data
company_name <- top_gainers$name
last_price <- str_split_fixed(top_gainers$latest_price_previous_close, '\r\n', 2)[,1]
top_gainers <- data.frame(company_name, last_price, percent_gain)

write_csv(top_gainers,paste0('project2/data/',Sys.Date(),'_top_gainers','.csv'))
