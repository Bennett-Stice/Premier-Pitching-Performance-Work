library(DBI)
library(RPostgres)
library(dplyr)
library(readr)

# Establish a connection to the database
con <- 

# Query the database and fetch the data into a data frame
query <- "select 	firstname ,lastname, AVG(release_speed) as AvgFastballVelo, MAX(release_speed) as MaxFastballVelo
from pitches p, athletes a
where a.group = 'College' and pitcher_name = concat(lastname,', ',firstname) and p.date > '2024-5-15' and pitch_type in ('FF','FT','FB','SI')
group by (firstname,lastname)
order by (AvgFastballVelo) DESC"


# Execute query and retrieve data into 'df'
df <- dbGetQuery(con, query)

# Close the database connection
dbDisconnect(con)

write.csv(df, "trackman_pitcher_avg_max_FB_Velo.csv", row.names = FALSE)
