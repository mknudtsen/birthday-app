
# Build initial calendar data frame (cal_df)
year_dates <- seq(as.Date("2015-01-01"), as.Date("2015-12-31"), by="days")

cal_df <- data.frame(month = format(year_dates, "%b"),
                     day = format(year_dates, "%d"),
                     name = format(year_dates, "%b %d"),
                     num = 1:365,
                     count = 0)


start_df <- data.frame(month = 30,
                       day = 30,
                       name = format(year_dates, "%b %d"),
                       num = 1:365,
                       count = "")

defaultColors <- c("#3366cc", "#dc3912", "#ff9900", "#109618", "#990099", "#0099c6", "#dd4477")
series <- structure(lapply(defaultColors, function(color) { list(color = color)}), 
                    names = levels(start_df$count))

xlim <- list( 
  min = 0,
  max = 32
)
ylim <- list(
  min = 0,
  max = 13
)


