# 06/04/2015
# This script plots bar graphs showing the count of each crime category 
# for each of the days of the week. Perhaps this will show some trend?
# Maybe Monday = Bribery day?

# v1. This is a first try. It still looks quite chaotic. I'll try to get a 
# better separaton of the X-labels. Any feedback is more than welcome!

# v2. I increased the size of the plot when it gets saved to .png. I also
# removed the legend, because the x-labels are clear enough. It looks 
# much better now!

# v3. Added a similar plot, breaking down the crime categories per district

library(dplyr)
library(reshape2)
library(ggplot2)
library(readr)
library(lubridate)

# Read in the training data
data <- read_csv("data/original/train.csv.zip",col_types = list(Dates = col_datetime()))

# Build a contingency table of all combinations of crime categories and days of the week
crimes_by_day <- table(data$Category,data$DayOfWeek)

# Reshape the table, so I can plot it later
crimes_by_day <- melt(crimes_by_day)
names(crimes_by_day) <- c("Category","DayOfWeek","Count")

# Make bar plots
g <- ggplot(crimes_by_day,aes(x=Category, y=Count,fill = Category)) + 
  geom_bar(stat = "Identity") + 
  coord_flip() +
  facet_grid(.~DayOfWeek) +
  theme(legend.position = "none")

ggsave(g, file="plots/Crimes_by_day.png", width=20, height=8)


################## Same, but for police district

crimes_by_district <- table(data$Category,data$PdDistrict)

crimes_by_district <- melt(crimes_by_district)
names(crimes_by_district) <- c("Category","PdDistrict","Count")

g <- ggplot(crimes_by_district,aes(x=Category, y=Count,fill = Category)) + 
  geom_bar(stat = "Identity") + 
  coord_flip() +
  facet_grid(.~PdDistrict) +
  theme(legend.position = "none")

ggsave(g, file="plots/Crimes_by_district.png", width=20, height=8)

################## Same, but for year. There are some differences in the counts here.

# Add a column for Year data
data$Year <- year(ymd_hms(data$Dates))

crimes_by_year <- table(data$Category,data$Year)

crimes_by_year <- melt(crimes_by_year)
names(crimes_by_year) <- c("Category","Year","Count")

g <- ggplot(crimes_by_year,aes(x=Category, y=Count,fill = Category)) + 
  geom_bar(stat = "Identity") + 
  coord_flip() +
  facet_grid(.~Year) +
  theme(legend.position = "none")

ggsave(g, file="plots/Crimes_by_year.png", width=20, height=8)



