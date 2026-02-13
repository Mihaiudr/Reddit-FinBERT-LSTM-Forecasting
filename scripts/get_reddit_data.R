library(RedditExtractoR)


subreddits <- c("stocks", "news", "finance")
search_list <- list(
  # Companii Tech
  "SPY"       = c("S&P", "S&P 500", "S&P500", "SPY"),
  "Google"    = c("Google", "GOOG", "Alphabet"),
  "Microsoft" = c("Microsoft", "MSFT"),
  "Berkshire" = c("Berkshire", "BRK.B", "Warren Buffett"),
  "JNJ"       = c("Johnson & Johnson", "JNJ"),
  "PG"        = c("Procter & Gamble", "P&G", "PG"),
  
  # Market Monitor (Starea Pieței)
  "Macro_Bear" = c("crash", "recession", "bear market", "sell off", "correction", "depression"),
  "Macro_Bull" = c("bull market", "rally", "ath", "all time high", "to the moon"),
  "Economy"    = c("inflation", "FED", "interest rates", "CPI", "Powell", "GDP")
)
all_data <- list()

cat("Începe extracția din mai multe subreddituri...\n")

for (sub in subreddits) {
  cat(paste0("\n--- Intrare în r/", sub, " ---\n"))
  
  for (company in tech_companies) {
    cat(paste0("  Căutăm ", company, "... "))
    
    threads <- tryCatch({
      find_thread_urls(
        keywords = company, 
        subreddit = sub, 
        sort_by = "relevance", 
        period = "all"
      )
    }, error = function(e) return(NULL))
    
    if (!is.null(threads) && is.data.frame(threads) && nrow(threads) > 0) {
      threads <- head(threads, 500)
      
      # Păstrăm și numele subredditului ca să știm de unde a venit știrea
      threads <- threads[, c("date_utc", "title", "url")]
      threads$subreddit <- sub
      threads$company <- company
      
      all_data <- append(all_data, list(threads))
      cat(paste0(nrow(threads), " găsite.\n"))
    } else {
      cat("0 găsite.\n")
    }
    
    # Pauză scurtă între companii
    Sys.sleep(1.2) 
  }
}

if (length(all_data) > 0) {
  combined_data <- do.call(rbind, all_data)
  
  #eliminare postari identice
  combined_data <- combined_data[!duplicated(combined_data$url), ]
  
  #sortare cronologica
  sorted_data <- combined_data[order(combined_data$date_utc), ]
  
  if (!dir.exists("data")) dir.create("data")
  write.csv(sorted_data, "data/reddit_data.csv", row.names = FALSE)
  
  cat(paste0("\nFinalizat! Total titluri unice din toate sursele: ", nrow(sorted_data), "\n"))
}