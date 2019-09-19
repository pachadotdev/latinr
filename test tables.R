aaa = fread2("04-unified-data/hs-rev2007/hs-rev2007-2017.csv.gz", character = "product_code") %>% 
  filter(reporter_iso == "fji", partner_iso == "usa")

bbb = fread2("06-tables/hs-rev2007/1-yrpc/yrpc-2017.csv.gz", character = "product_code") %>% 
  filter(reporter_iso == "fji", partner_iso == "usa")

library(jsonlite)

x = fromJSON("https://api.tradestatistics.io/yrpc?y=2017&r=fji&p=usa")

library(tradestatistics)

# esto debe tener 736 obs !!!
fji_usa <- ots_create_tidy_data(
  years = 2017, reporters = "fji", partners = "usa",
  include_shortnames = T
)

fji_usa %>% 
  select(product_shortname_english, export_value_usd) %>% 
  arrange(-export_value_usd) %>% 
  mutate(export_value_share = round(100 * export_value_usd /
                                      sum(export_value_usd, na.rm = T), 2))

aaa %>% 
  rename(export_value_usd = trade_value_usd) %>% 
  left_join(ots_product_shortnames) %>% 
  select(product_shortname_english, export_value_usd) %>% 
  arrange(-export_value_usd) %>% 
  mutate(export_value_share = round(100 * export_value_usd /
                                      sum(export_value_usd, na.rm = T), 2))

bbb %>% 
  left_join(ots_product_shortnames) %>% 
  select(product_shortname_english, export_value_usd) %>% 
  arrange(-export_value_usd) %>% 
  mutate(export_value_share = round(100 * export_value_usd /
                                      sum(export_value_usd, na.rm = T), 2))
