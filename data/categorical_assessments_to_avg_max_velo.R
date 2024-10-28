# Load Packages
library(dplyr)
library(randomForest)
library(caret)

# Load in assessment data and pitch velocity data
assessment_data <- read.csv("assessment_data.csv")
avg_max_fb_velo <- read.csv("trackman_pitcher_avg_max_FB_velo.csv")

# Combine the datasets
combined_data <- inner_join(assessment_data, avg_max_fb_velo, by = c("firstname", "lastname"))

# Select the columns you want to keep (adjust this list as necessary)
columns_to_keep <- c("firstname", "lastname", "throwing.side", "avgfastballvelo", "maxfastballvelo", 
                     "cervical.active.rom.extension", "cervical.active.rom.flexion",
                     "cervical.active.rom.left.rotation", "cervical.active.rom.right.rotation", 
                     "elbow.extension.left", "elbow.extension.right", "hip.bias.left", "hip.bias.right", 
                     "hip.hamstring.left", "hip.hamstring.right", "hip.prone.quad.length.left", 
                     "hip.prone.quad.length.right", "hip.rotational.arc.left", "hip.rotational.arc.right",
                     "hip.thomas.test.left", "hip.thomas.test.right", "movement.standing.flexion", 
                     "scap.eval.0deg.left", "scap.eval.0deg.right", "scap.eval.90deg.left", 
                     "scap.eval.90deg.right", "side.step.walkout", "spine.cervical", "spine.lumbar", 
                     "spine.thoracic", "strided.extension.left.forward", "strided.extension.right.forward", 
                     "thoracic.rotation.left", "thoracic.rotation.right", "barbell.rdl", "front.squat", 
                     "lateral.lunge.left", "lateral.lunge.right", "pushup", "reverse.lunge.left", 
                     "reverse.lunge.right")

# Select only the specified columns
cleaned_data <- combined_data %>% select(all_of(columns_to_keep))

# Create new features based on throwing side
cleaned_data <- cleaned_data %>%
  mutate(
    cervical.active.rom.rotation.throwing = if_else(throwing.side == "Left", cervical.active.rom.left.rotation, cervical.active.rom.right.rotation),
    cervical.active.rom.rotation.non.throwing = if_else(throwing.side == "Left", cervical.active.rom.right.rotation, cervical.active.rom.left.rotation),
    
    elbow.extension.throwing = if_else(throwing.side == "Left", elbow.extension.left, elbow.extension.right),
    elbow.extension.non.throwing = if_else(throwing.side == "Left", elbow.extension.right, elbow.extension.left),
    
    hip.bias.throwing = if_else(throwing.side == "Left", hip.bias.left, hip.bias.right),
    hip.bias.non.throwing = if_else(throwing.side == "Left", hip.bias.right, hip.bias.left),
    
    hip.hamstring.throwing = if_else(throwing.side == "Left", hip.hamstring.left, hip.hamstring.right),
    hip.hamstring.non.throwing = if_else(throwing.side == "Left", hip.hamstring.right, hip.hamstring.left),
    
    hip.prone.quad.length.throwing = if_else(throwing.side == "Left", hip.prone.quad.length.left, hip.prone.quad.length.right),
    hip.prone.quad.length.non.throwing = if_else(throwing.side == "Left", hip.prone.quad.length.right, hip.prone.quad.length.left),
    
    hip.rotational.arc.throwing = if_else(throwing.side == "Left", hip.rotational.arc.left, hip.rotational.arc.right),
    hip.rotational.arc.non_throwing = if_else(throwing.side == "Left", hip.rotational.arc.right, hip.rotational.arc.left),
    
    hip.thomas.test.throwing = if_else(throwing.side == "Left", hip.thomas.test.left, hip.thomas.test.right),
    hip.thomas.test.non_throwing = if_else(throwing.side == "Left", hip.thomas.test.right, hip.thomas.test.left),
    
    scap.eval.0deg.throwing = if_else(throwing.side == "Left", scap.eval.0deg.left, scap.eval.0deg.right),
    scap.eval.0deg.non_throwing = if_else(throwing.side == "Left", scap.eval.0deg.right, scap.eval.0deg.left),
    
    scap.eval.90deg.throwing = if_else(throwing.side == "Left", scap.eval.90deg.left, scap.eval.90deg.right),
    scap.eval.90deg.non_throwing = if_else(throwing.side == "Left", scap.eval.90deg.right, scap.eval.90deg.left),
    
    strided.extension.forward.throwing = if_else(throwing.side == "Left", strided.extension.left.forward, strided.extension.right.forward),
    strided.extension.forward.non_throwing = if_else(throwing.side == "Left", strided.extension.right.forward, strided.extension.left.forward),
    
    thoracic.rotation.throwing = if_else(throwing.side == "Left", thoracic.rotation.left, thoracic.rotation.right),
    thoracic.rotation.non_throwing = if_else(throwing.side == "Left", thoracic.rotation.right, thoracic.rotation.left),
    
    lateral.lunge.throwing = if_else(throwing.side == "Left", lateral.lunge.left, lateral.lunge.right),
    lateral.lunge.non_throwing = if_else(throwing.side == "Left", lateral.lunge.right, lateral.lunge.left),
    
    reverse.lunge.throwing = if_else(throwing.side == "Left", reverse.lunge.left, reverse.lunge.right),
    reverse.lunge.non_throwing = if_else(throwing.side == "Left", reverse.lunge.right, reverse.lunge.left)
  )

# Remove the original .left and .right columns
cleaned_data <- cleaned_data %>%
  select(-ends_with(".left"), -ends_with(".right"), -strided.extension.left.forward, -strided.extension.right.forward, -cervical.active.rom.left.rotation, -cervical.active.rom.right.rotation)

# Create two separate datasets for avgfastballvelo and maxfastballvelo
cleaned_data_avg <- cleaned_data %>%
  select(-firstname, -lastname, -throwing.side, -maxfastballvelo)

cleaned_data_max <- cleaned_data %>%
  select(-firstname, -lastname, -throwing.side, -avgfastballvelo)

# Remove rows with NAs
cleaned_data_avg <- na.omit(cleaned_data_avg)
cleaned_data_max <- na.omit(cleaned_data_max)

# Train the random forest models
set.seed(42)
model_avg <- randomForest(avgfastballvelo ~ ., data = cleaned_data_avg, importance = TRUE)
model_max <- randomForest(maxfastballvelo ~ ., data = cleaned_data_max, importance = TRUE)

# Plot feature importance
varImpPlot(model_avg)
varImpPlot(model_max)

# Extract feature importance
avg_importance <- importance(model_avg)
max_importance <- importance(model_max)

# Convert importance matrices to data frames
avg_importance_df <- as.data.frame(avg_importance)
avg_importance_df$Feature <- rownames(avg_importance_df)

max_importance_df <- as.data.frame(max_importance)
max_importance_df$Feature <- rownames(max_importance_df)

# Merge the data frames on the Feature column
combined_importance_df <- merge(avg_importance_df, max_importance_df, by = "Feature", suffixes = c("_avg", "_max"))

# Write the combined data frame to a CSV file
write.csv(combined_importance_df, "Max_Avg_Velo_Categorical_Feature.csv", row.names = FALSE)

# Print the combined data frame to verify
print(combined_importance_df)
