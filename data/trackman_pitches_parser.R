library(DBI)
library(RPostgres)
library(dplyr)
library(readr)

# Establish a connection to the database
con 

# Query the database and fetch the data into a data frame
query <- "select 	firstname ,lastname, pitcher_throws,
		pitch_type, release_speed, plate_location_height, plate_location_side, release_height, release_side, extension, 
		horizontal_break, induced_vertical_break, vertical_break, horizontal_approach_angle, vertical_approach_angle, horizontal_release_angle, vertical_release_angle,
		spin_rate, spin_axis, spin_efficiency, tilt, date, time
from pitches p, athletes a
where a.group = 'College' and pitcher_name = concat(lastname,', ',firstname) and p.date > '2024-5-15'"


updated_query <- "select 	firstname ,lastname, pitcher_throws,
		pitch_type, release_speed, plate_location_height, plate_location_side, release_height, release_side, extension, 
		horizontal_break, induced_vertical_break, vertical_break, horizontal_approach_angle, vertical_approach_angle, horizontal_release_angle, vertical_release_angle,
		spin_rate, spin_axis, spin_efficiency, tilt, date, time
from pitches p, athletes a
<<<<<<< HEAD
where pitcher_name = concat(lastname,', ',firstname) and 
release_speed>=80 and pitch_type in ('FB','SI') and p.date > '2020-1-1'"
=======
where a.group = 'College' and pitcher_name = concat(lastname,', ',firstname) and
release_speed>=80 and pitch_type in ('FB', 'SI') and p.date > '2020-1-1'"
>>>>>>> 6fdd56d54ab0f93d2fcc7760ef836afdd6fbd3bf

# Execute query and retrieve data into 'df'
df <- dbGetQuery(con, updated_query)

# Close the database connection
dbDisconnect(con)

write.csv(df, "zzztrackman_pitch_data_greater_than80_new.csv", row.names = FALSE)
