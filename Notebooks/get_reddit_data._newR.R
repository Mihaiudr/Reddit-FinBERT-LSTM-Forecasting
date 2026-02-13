library(RedditExtractoR)

# 1. Extindem search_list cu categorii de piață (Bull/Bear/Macro)
search_list <- list(
  # --- MAGNIFICENT SEVEN (Cei care mișcă piața cel mai mult) ---
  "NVDA"      = c("NVIDIA", "NVDA"),
  "AAPL"      = c("Apple", "AAPL"),
  "MSFT"      = c("Microsoft", "MSFT"),
  "GOOGL"     = c("Google", "GOOGL", "Alphabet"),
  "AMZN"      = c("Amazon", "AMZN"),
  "META"      = c("Meta", "Facebook", "META"),
  "TSLA"      = c("Tesla", "TSLA"),
  
  # --- SEMICONDUCTORI & TECH (Inima S&P500 acum) ---
  "AVGO"      = c("Broadcom", "AVGO"),
  "AMD"       = c("AMD"),
  "INTC"      = c("Intel", "INTC"),
  "CRM"       = c("Salesforce", "CRM"),
  "ORCL"      = c("Oracle", "ORCL"),
  
  # --- FINANCIAR (Bănci și Plăți) ---
  "JPM"       = c("JPMorgan", "JPM"),
  "BAC"       = c("Bank of America", "BAC"),
  "GS"        = c("Goldman Sachs", "GS"),
  "V_MA"      = c("Visa", "Mastercard", "V", "MA"),
  "BRK"       = c("Berkshire Hathaway", "BRK.B", "Warren Buffett"),
  
  # --- SĂNĂTATE (Healthcare) ---
  "LLY"       = c("Eli Lilly", "LLY"),
  "UNH"       = c("UnitedHealth", "UNH"),
  "JNJ"       = c("Johnson & Johnson", "JNJ"),
  "PFE"       = c("Pfizer", "PFE"),
  
  # --- ENERGIE & INDUSTRIE ---
  "XOM_CVX"   = c("Exxon Mobil", "XOM", "Chevron", "CVX"),
  "BA"        = c("Boeing", "BA"),
  "CAT"       = c("Caterpillar", "CAT"),
  
  # --- CONSUM & RETAIL ---
  "WMT"       = c("Walmart", "WMT"),
  "HD"        = c("Home Depot", "HD"),
  "PG"        = c("Procter & Gamble", "P&G", "PG"),
  "KO_PEP"    = c("Coca-Cola", "KO", "Pepsi", "PEP"),
  "COST"      = c("Costco", "COST"),
  
  # --- MARKET SENTIMENT & MACRO (Cuvinte cheie financiare) ---
  "Bullish"   = c("bull market", "rally", "ath", "all time high", "to the moon", "buy the dip"),
  "Bearish"   = c("bear market", "crash", "recession", "sell off", "correction", "bubble", "capitulation"),
  "Macro"     = c("inflation", "FED", "interest rates", "CPI", "Jerome Powell", "FOMC", "GDP"),
  "SP500_Gen" = c("S&P 500", "SP500", "SPY", "VOO", "index fund", "market sentiment")
)
subreddits <- c("stocks","news", "investing", "wallstreetbets", "finance", "economy", "stockmarket")

all_data <- list()
data_limita <- as.Date("2026-02-12")
data_start  <- as.Date("2022-01-01")

cat("Începe extracția datelor (2022 - prezent)...\n")

for (sub in subreddits) {
  cat(paste0("\n--- Subreddit: r/", sub, " ---\n"))
  
  for (category in names(search_list)) {
    keywords <- search_list[[category]]
    
    for (key in keywords) {
      cat(paste0("  Căutăm '", key, "'... "))
      
      threads <- tryCatch({
        find_thread_urls(
          keywords = key, 
          subreddit = sub, 
          sort_by = "new", 
          period = "all"
        )
      }, error = function(e) return(NULL))
      
      if (!is.null(threads) && nrow(threads) > 0) {
        # Conversie dată și filtrare interval
        threads$date_utc <- as.Date(threads$date_utc)
        threads <- threads[threads$date_utc >= data_start & threads$date_utc <= data_limita, ]
        
        if(nrow(threads) > 0) {
          threads$subreddit <- sub
          threads$category <- category
          threads$keyword_used <- key
          
          all_data[[length(all_data) + 1]] <- threads
          cat(paste0(nrow(threads), " stiri.\n"))
        } else {
          cat("0 in interval.\n")
        }
      } else {
        cat("0 gasite.\n")
      }
      
      # Pauza obligatorie pentru a evita blocarea IP-ului de catre Reddit
      Sys.sleep(1.5) 
    }
  }
}

# 2. Salvarea rezultatelor
if (length(all_data) > 0) {
  combined_data <- do.call(rbind, all_data)
  
  # Eliminam postarile care apar in mai multe cautari (dupa URL unic)
  combined_data <- combined_data[!duplicated(combined_data$url), ]
  
  # Ordonam de la cele mai noi la cele mai vechi
  combined_data <- combined_data[order(combined_data$date_utc, decreasing = TRUE), ]
  
  if (!dir.exists("data")) dir.create("data")
  write.csv(combined_data, "data/reddit_finance_data_2022_2026.csv", row.names = FALSE)
  
  cat(paste0("\nFinalizat! Total titluri unice colectate: ", nrow(combined_data), "\n"))
} else {
  cat("\nNu s-au gasit date conform criteriilor.\n")
}

