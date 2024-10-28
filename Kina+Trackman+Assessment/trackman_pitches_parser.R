library(DBI)
library(RPostgres)
library(dplyr)
library(readr)
library(lubridate)

# Establish a connection to the database
con <- 

# Query the database and fetch the data into a data frame
query <- "select 	firstname ,lastname, pitcher_throws,
		pitch_type, release_speed, plate_location_height, plate_location_side, release_height, release_side, extension, 
		horizontal_break, induced_vertical_break, vertical_break, horizontal_approach_angle, vertical_approach_angle, horizontal_release_angle, vertical_release_angle,
		spin_rate, spin_axis, spin_efficiency, tilt, date, time
from pitches p, athletes a
where pitch_type in ('FB','SI') and pitcher_name = concat(lastname,', ',firstname) and p.date > '2023-01-01' and release_speed>80"

# Execute query and retrieve data into 'df'
df <- dbGetQuery(con, query)

# Convert time to POSIXct format if not already
df$time <- as.POSIXct(df$time, format = "%H:%M:%OS")

# Round the time to the nearest second
df$time <- round(df$time, units = "secs")

# Convert time back to character format if needed
df$time <- format(df$time, format = "%H:%M:%S")

# Close the database connection
dbDisconnect(con)

# Save the data to a CSV file
write.csv(df, "trackman_pitch_data_FB_above_80.csv", row.names = FALSE)
