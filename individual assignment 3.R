
#i will download special offer products from https://www.notino.hu/
# the search result base is https://www.notino.hu/search.asp?exps=mac
# the second page lokks like this:https://www.notino.hu/search/?exps=mac&f=2-1

library(rvest)
library(data.table)
library(xml2)
library(RCurl)

my_search_term <- 'mac'
page_to_download <- 5
my_base_url <-paste0("https://www.notino.hu/search/?exps=",my_search_term)

#OK! now put it into a function

get_one_page <- function(my_base_url){
  print(my_base_url)
  # make dataframe of one page_one_
  t <- read_html(my_base_url)
  write_html(t,'t.html')
  my_titles <- 
    t %>%
    html_nodes('.name strong')%>%
    html_text() 
 
  my_price <- 
    t %>%
    html_nodes('.price strong')%>%
    html_text() 
  
  mylinks <- 
    t %>%
    html_nodes('.spc')%>%
    html_attr('href')

  

   
 page <- data.table(Names = my_titles,price_in_HUF =my_price, links= mylinks)
  return(page)
  
}



first_link <- paste0("https://www.notino.hu/search/?exps",my_search_term)

# the rest

rest_link <- paste0('https://www.notino.hu/search/?exps=',my_search_term,'&f=',c(2:page_to_download),'-1')
View(rest_link)
my_links<- c(first_link,rest_link)
my_links

df_lists  <- lapply(my_links, get_one_page)

final_df <- rbindlist(df_lists)

write.csv(final_df,'LF price list')

saveRDS(final_df, 'individual assigment 3.rds')
