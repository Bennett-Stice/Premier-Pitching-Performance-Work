# Load in packages
library(DBI)
library(RPostgres)
library(jsonlite)
library(dplyr)
library(tidyr)
library(readr)

# Establish a connection to the database
con <-

# Query the database and fetch the data into a data frame
query <- "select firstname, lastname, assessment_name, assessment_data 
from athletes, assessment_data
where athlete_id = athletes.id and athletes.group = 'College' and assessment_data.date > '2024-5-15'"


# Execute query and retrieve data into 'df'
df <- dbGetQuery(con, query)

# Close the database connection
dbDisconnect(con)

# Initialize an empty list to store all individual row data frames
all_results <- list()

# Loop through each row in 'df'
for (i in 1:nrow(df)) {
  firstname <- df[i, "firstname"]
  lastname <- df[i, "lastname"]
  assessment_data <- df[i, "assessment_data"]
  
  # Parse assessment_data JSON string into data_list
  data_list <- fromJSON(assessment_data, simplifyVector = FALSE)
  
  # Initialize vectors to store results for this row
  row_id_values <- character()
  row_response_values <- character()
  
  # Iterate through data_list to extract id and response values
  for (obj in data_list) {
    id_value <- obj$id
    response_value <- obj$response
    
    # Check if response_value is not NULL
    if (!is.null(response_value)) {
      # Create a data frame for this row of data_list
      row_df <- data.frame(firstname = firstname,
                           lastname = lastname,
                           id_value = id_value,
                           response_value = response_value,
                           stringsAsFactors = FALSE)
      
      # Append 'row_df' to 'all_results' list
      all_results <- c(all_results, list(row_df))
    }
  }
}

# Combine all data frames into a single data frame
df_final <- do.call(rbind, all_results)


df_reshaped <- df_final %>%
  group_by(firstname, lastname, id_value) %>%
  summarise(response_value = first(response_value)) %>%
  pivot_wider(
    names_from = id_value,
    values_from = response_value,
    names_glue = "{id_value}"
  )

df_reshaped <- df_reshaped[-is.na(df_reshaped$throwing.side)]

write.csv(df_reshaped, "assessment_data.csv", row.names = FALSE)

dalton_stats <- df_reshaped[, c("firstname", "lastname", 
                                "cmj-jump-height-cm", "cmj-peak-force-n", "imtp-peak-force-n", 
                                "medball-throws-overhead-throw-4lb-mph", "medball-throws-scoop-throw-6lb-mph", 
                                "medball-throws-shotput-toss-6lb-mph", "single-leg-lateral-jump-inches-left", 
                                "single-leg-lateral-jump-inches-right", "squat-jump-height-cm")]

write.csv(dalton_stats, "Dalton_Stats.csv", row.names = FALSE)
