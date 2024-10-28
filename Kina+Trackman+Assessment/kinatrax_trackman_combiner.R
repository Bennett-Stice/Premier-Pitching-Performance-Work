library(dplyr)

# Read data frames
KinaTrax <- read.csv("kinatraxvalues_combined.csv")
TrackMan <- read.csv("trackman_pitch_data_FB_above_80.csv")

# Convert KinaTrax and TrackMan date and time columns to POSIXct format
KinaTrax$DateTime <- as.POSIXct(paste(KinaTrax$Date, KinaTrax$Time), format = "%Y-%m-%d %H:%M:%S")
TrackMan$DateTime <- as.POSIXct(paste(TrackMan$date, TrackMan$time), format = "%Y-%m-%d %H:%M:%S")


# Create a list to store merged data frames
merged_data_list <- list()

# Loop through different hour offsets
for (hour in -10:10) {
  # Create a temporary list to store merged data frames for each offset within the current hour
  temp_merged_data_list <- list()
  
  # Loop through different second offsets from -15 to 15 and merge data
  for (offset in 0:12) {
    # Adjust TrackMan time to match KinaTrax
    TrackMan$DateTime_adjusted <- TrackMan$DateTime - as.difftime(hour * 3600 + offset, units = "secs")
    
    # Merge based on adjusted DateTime
    merged_data <- merge(KinaTrax, TrackMan, by.x = "DateTime", by.y = "DateTime_adjusted")
    
    # Store merged data frame in the temporary list
    temp_merged_data_list[[offset + 16]] <- merged_data  # Offset + 16 to handle negative offsets correctly
  }
  
  # Combine all merged data frames within the current hour into one
  data_part <- do.call(rbind, temp_merged_data_list)
  
  # Print how many rows were added in the current hour
  cat("Hour", hour, ":", nrow(data_part), "rows added\n")
  
  # Store the combined data frame into the main list
  merged_data_list[[hour + 11]] <- data_part  # Hour + 11 to handle negative hours correctly
}




# Combine all merged data frames into one final data frame
final_merged_data <- do.call(rbind, merged_data_list)

all_data_sorted <- final_merged_data[order(final_merged_data$DateTime), ]
all_data_sorted <- all_data_sorted[!duplicated(all_data_sorted), ]


over_85 <- all_data_sorted %>%
  filter(release_speed>85)

over_90 <- over_85 %>%
  filter(release_speed>90)

over_95 <- over_90 %>%
  filter(release_speed>95)

write.csv(all_data_sorted, "Kinatrax+Trackman_over80.csv", row.names = FALSE)
write.csv(over_85, "Kinatrax+Trackman_over85.csv", row.names = FALSE)
write.csv(over_90, "Kinatrax+Trackman_over90.csv", row.names = FALSE)
write.csv(over_95, "Kinatrax+Trackman_over95.csv", row.names = FALSE)


