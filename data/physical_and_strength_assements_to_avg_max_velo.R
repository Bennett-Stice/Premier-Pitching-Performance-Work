# Load Packages
library(dplyr)


# Load in assement data and pitch velocity data
assessment_data <- read.csv("assessment_data.csv")
avg_max_fb_velo <- read.csv("trackman_pitcher_avg_max_FB_velo.csv")


combined_data <- inner_join(assessment_data, avg_max_fb_velo, by = c("firstname", "lastname"))


# Select the columns you want to keep (adjust this list as necessary)
columns_to_keep <- c("firstname", "lastname","throwing.side", "avgfastballvelo","maxfastballvelo","X10.year.sprint.seconds.laser", "ankle.dorsiflexion.left",
                     "ankle.dorsiflexion.right","bodyweight","broad.jump.inches","cmj.jump.height.cm","cmj.peak.force.n", "imtp.peak.force.n",
                     "dynamic.strength.index","eccentric.utilization.ratio","single.leg.lateral.jump.inches.left","single.leg.lateral.jump.inches.right",
                     "squat.jump.height.cm","grip.strength.left","grip.strength.right","hip.prone.external.rotation.left",
                     "hip.prone.external.rotation.right", "hip.prone.internal.rotation.left","hip.prone.internal.rotation.right",
                     "hip.seated.external.rotation.90.left", "hip.seated.external.rotation.90.right","hip.seated.internal.rotation.90.left",
                     "hip.seated.internal.rotation.90.right", "medball.throws.overhead.throw.4lb.mph", "medball.throws.scoop.throw.6lb.mph",
                     "medball.throws.shotput.toss.6lb.mph","shoulder.flexion.left","shoulder.flexion.right","shoulder.flexion.scap.stabilized.left",
                     "shoulder.flexion.scap.stabilized.right","shoulder.horizontal.abduction.left","shoulder.horizontal.abduction.right",
                     "shoulder.internal.rotation.left","shoulder.internal.rotation.right","shoulder.prone.active.er.left", "shoulder.prone.active.er.right",
                     "shoulder.total.range.left","shoulder.total.range.right")

# Select only the specified columns
cleaned_data <- combined_data %>% select(all_of(columns_to_keep))

# Ensure throwing.side is of correct type
cleaned_data$throwing.side <- as.character(cleaned_data$throwing.side)


cleaned_data <- cleaned_data %>%
  mutate(
    ankle.dorsiflexion.throwing = if_else(throwing.side == "Left", ankle.dorsiflexion.left, ankle.dorsiflexion.right),
    ankle.dorsiflexion.non.throwing = if_else(throwing.side == "Left", ankle.dorsiflexion.right, ankle.dorsiflexion.left),
    
    single.leg.lateral.jump.inches.throwing = if_else(throwing.side == "Left", single.leg.lateral.jump.inches.left, single.leg.lateral.jump.inches.right),
    single.leg.lateral.jump.inches.non.throwing = if_else(throwing.side == "Left", single.leg.lateral.jump.inches.right, single.leg.lateral.jump.inches.left),
    
    grip.strength.throwing = if_else(throwing.side == "Left", grip.strength.left, grip.strength.right),
    grip.strength.non.throwing = if_else(throwing.side == "Left", grip.strength.right, grip.strength.left),
    
    hip.prone.external.rotation.throwing = if_else(throwing.side == "Left", hip.prone.external.rotation.left, hip.prone.external.rotation.right),
    hip.prone.external.rotation.non.throwing = if_else(throwing.side == "Left", hip.prone.external.rotation.right, hip.prone.external.rotation.left),
    
    hip.prone.internal.rotation.throwing = if_else(throwing.side == "Left", hip.prone.internal.rotation.left, hip.prone.internal.rotation.right),
    hip.prone.internal.rotation.non.throwing = if_else(throwing.side == "Left", hip.prone.internal.rotation.right, hip.prone.internal.rotation.left),
    
    hip.seated.external.rotation.90.throwing = if_else(throwing.side == "Left", hip.seated.external.rotation.90.left, hip.seated.external.rotation.90.right),
    hip.seated.external.rotation.90.non.throwing = if_else(throwing.side == "Left", hip.seated.external.rotation.90.right, hip.seated.external.rotation.90.left),
    
    hip.seated.internal.rotation.90.throwing = if_else(throwing.side == "Left", hip.seated.internal.rotation.90.left, hip.seated.internal.rotation.90.right),
    hip.seated.internal.rotation.90.non.throwing = if_else(throwing.side == "Left", hip.seated.internal.rotation.90.right, hip.seated.internal.rotation.90.left),
    
    shoulder.flexion.throwing = if_else(throwing.side == "Left", shoulder.flexion.left, shoulder.flexion.right),
    shoulder.flexion.non.throwing = if_else(throwing.side == "Left", shoulder.flexion.right, shoulder.flexion.left),
    
    shoulder.flexion.scap.stabilized.throwing = if_else(throwing.side == "Left", shoulder.flexion.scap.stabilized.left, shoulder.flexion.scap.stabilized.right),
    shoulder.flexion.scap.stabilized.non.throwing = if_else(throwing.side == "Left", shoulder.flexion.scap.stabilized.right, shoulder.flexion.scap.stabilized.left),
    
    shoulder.horizontal.abduction.throwing = if_else(throwing.side == "Left", shoulder.horizontal.abduction.left, shoulder.horizontal.abduction.right),
    shoulder.horizontal.abduction.non.throwing = if_else(throwing.side == "Left", shoulder.horizontal.abduction.right, shoulder.horizontal.abduction.left),
    
    shoulder.internal.rotation.throwing = if_else(throwing.side == "Left", shoulder.internal.rotation.left, shoulder.internal.rotation.right),
    shoulder.internal.rotation.non.throwing = if_else(throwing.side == "Left", shoulder.internal.rotation.right, shoulder.internal.rotation.left),
    
    shoulder.prone.active.er.throwing = if_else(throwing.side == "Left", shoulder.prone.active.er.left, shoulder.prone.active.er.right),
    shoulder.prone.active.er.non.throwing = if_else(throwing.side == "Left", shoulder.prone.active.er.right, shoulder.prone.active.er.left),
    
    shoulder.total.range.throwing = if_else(throwing.side == "Left", shoulder.total.range.left, shoulder.total.range.right),
    shoulder.total.range.non.throwing = if_else(throwing.side == "Left", shoulder.total.range.right, shoulder.total.range.left)
  )

  

# Remove the original .left and .right columns
cleaned_data <- cleaned_data %>%
  select(-ends_with(".left"), -ends_with(".right"))

# Select all numeric columns except for firstname, lastname, throwing.side
number_columns <- cleaned_data %>%
  select(-firstname, -lastname, -throwing.side) %>%
  select(where(is.numeric))

# Add percentile columns, multiply by 100, and round to the nearest whole number
percentile_columns <- number_columns %>%
  mutate(across(everything(), ~round(percent_rank(.) * 100))) %>%
  rename_with(~paste0(., "_percentile"))

# Combine original data with percentile columns
cleaned_data_with_percentiles <- cbind(cleaned_data, percentile_columns)

# Sort columns to place percentile columns next to their corresponding value columns
sorted_columns <- unlist(lapply(names(number_columns), function(col) {
  c(col, paste0(col, "_percentile"))
}))

# Rearrange the data frame with sorted columns
cleaned_data_with_percentiles <- cleaned_data_with_percentiles %>%
  select(firstname, lastname, throwing.side, avgfastballvelo, maxfastballvelo, all_of(sorted_columns))

# Write the cleaned data with percentiles to a new CSV file
write.csv(cleaned_data_with_percentiles, "assessment_and_avg_max_velo_combined_data.csv", row.names = FALSE)



# Select all numeric columns except for firstname, lastname, throwing.side, avgfastballvelo, and maxfastballvelo
numeric_columns <- cleaned_data %>%
  select(-firstname, -lastname, -throwing.side, -avgfastballvelo, -maxfastballvelo) %>%
  select(where(is.numeric))

# Initialize a list to store correlation results
correlation_results <- list()

for (var_name in names(numeric_columns)) {
  
  # Calculate correlations with avgfastballvelo
  correlation_avg <- cor(cleaned_data$avgfastballvelo, cleaned_data[[var_name]], method = "pearson", use = "complete.obs")
  rounded_correlation_avg <- round(correlation_avg, digits = 3)  # Round to the thousandth place
  
  # Calculate correlations with maxfastballvelo
  correlation_max <- cor(cleaned_data$maxfastballvelo, cleaned_data[[var_name]], method = "pearson", use = "complete.obs")
  rounded_correlation_max <- round(correlation_max, digits = 3)  # Round to the thousandth place
  
  # Scatter plot for avgfastballvelo
  png(filename = paste0("Correlation_Graphs/", var_name, "_vs_avgfastballvelo.png"))
  plot(cleaned_data[[var_name]], cleaned_data$avgfastballvelo,
       xlab = var_name, ylab = "avgfastballvelo",
       main = paste(var_name, "vs avgfastballvelo", "\nCorrelation:", rounded_correlation_avg))
  abline(lm(cleaned_data$avgfastballvelo ~ cleaned_data[[var_name]]), col = "red")
  dev.off()
  
  # Scatter plot for maxfastballvelo
  png(filename = paste0("Correlation_Graphs/", var_name, "_vs_maxfastballvelo.png"))
  plot(cleaned_data[[var_name]], cleaned_data$maxfastballvelo,
       xlab = var_name, ylab = "maxfastballvelo",
       main = paste(var_name, "vs maxfastballvelo", "\nCorrelation:", rounded_correlation_max))
  abline(lm(cleaned_data$maxfastballvelo ~ cleaned_data[[var_name]]), col = "blue")
  dev.off()
  
  cat(paste("\nCorrelation between avgfastballvelo and", var_name, ":", correlation_avg, "\n"))
  cat(paste("\nCorrelation between maxfastballvelo and", var_name, ":", correlation_max, "\n"))
  
  # Store correlation results
  correlation_results[[var_name]] <- list(KPI = var_name,
                                          Average_Fastball_Velo = round(correlation_avg, 3),
                                          Max_Fastball_Velo = round(correlation_max, 3))
}

# Convert correlation_results to a data frame
correlation_df <- data.frame(do.call(rbind, correlation_results))

# Convert list columns to character vectors
correlation_df[] <- lapply(correlation_df, function(x) {
  if (is.list(x)) {
    sapply(x, toString)
  } else {
    x
  }
})

# Convert numeric columns from character to numeric
correlation_df$Average_Fastball_Velo <- as.numeric(correlation_df$Average_Fastball_Velo)
correlation_df$Max_Fastball_Velo <- as.numeric(correlation_df$Max_Fastball_Velo)

# Order the dataframe by Average_Fastball_Velo
correlation_df <- correlation_df[order(-correlation_df$Average_Fastball_Velo), ]

# Print the correlations table
print(correlation_df)

# Write correlation_df to CSV file
write.csv(correlation_df, "assessment_and_avg_max_velo_correlations.csv", row.names = FALSE)

