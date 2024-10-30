x <- readxl::read_xlsx("eBird_live_summary/ABCD_2024_summary.xlsx", sheet = 2)


gen_ebird_barchart(x)

###



event_date <- seq(lubridate::today() - 1, lubridate::today(), by = "days")
event_code = "GBBC"

speclist <- get_admin_codes("IN-KL", hi_arch = FALSE) %>%
  gen_spec_list(dates = event_date) 

x <- get_admin_codes("IN-KL", hi_arch = FALSE) %>%
  gen_part_summ(dates = event_date, list_spec = speclist) 



x %>% 
  dplyr::select(REGION, REGION.NAME, TOTAL, ALL.DAYS) %>% 
  pivot_wider(names_from = "TOTAL", values_from = "ALL.DAYS") %>% 
  # rowwise() %>% 
  mutate(TEXT = gen_textual_summ(SPECIES, NULL, CHECKLISTS, 
                                 event_code = "GBBC", 
                                 event_day = NULL)) %>% 
  dplyr::select(-c(SPECIES, OBSERVERS, CHECKLISTS))
    

y <- x %>% 
  dplyr::select(REGION, REGION.NAME, TOTAL, ALL.DAYS) %>% 
  pivot_wider(names_from = "TOTAL", values_from = "ALL.DAYS")

day_of <- "In "

line1 <- "Congratulations to everyone! "

line2a <- glue("{day_of}{str_replace(event_code, '_', ' ')}, ")
line2b <- if (!is.null(NULL)) glue("{observers} observers ") else glue("observers ")
line2c <- glue("reported an list of {y$SPECIES} species ")
line2d <- glue("from {y$CHECKLISTS} checklists!")

summary_text <- glue("{line1}{line2a}{line2b}{line2c}{line2d}")

return(summary_text)




