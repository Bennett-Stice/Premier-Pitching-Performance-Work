library(dplyr)
library(randomForest)
library(pdp)
library(ggplot2)
library(caret)  # For hyperparameter tuning

# Read the data
data <- read.csv("Boost_BioMech_Metrics_And_Velos_greater_than_80.csv")

data$Lead_Knee_Flexion_BR_delta <- data$Lead_Knee_Flexion_BR - data$Lead_Knee_Flexion_FC
data$Lead_Knee_Flexion_MER_delta <- data$Lead_Knee_Flexion_MER - data$Lead_Knee_Flexion_FC

# Select relevant columns
velocities <- data %>% 
  select(Velocity)

x_values <- data %>%
  select(-Pitch_Type, -Velocity, 
         -Plate_Location_Height, -Plate_Location_Side, 
         -Induced_Vertical_Break, -Horizontal_Break, 
         -Vertical_Approach_Angle, -Horizontal_Approach_Angle) %>%
  select_if(is.numeric)

model_data <- na.omit(cbind(x_values, Velocity = velocities$Velocity))


# Remove outliers based on IQR
remove_outliers <- function(df) {
  for (col in names(df)) {
    if (is.numeric(df[[col]])) {
      Q1 <- quantile(df[[col]], 0.25, na.rm = TRUE)
      Q3 <- quantile(df[[col]], 0.75, na.rm = TRUE)
      IQR <- Q3 - Q1
      df <- df %>%
        filter(df[[col]] >= (Q1 - 1.5 * IQR) & df[[col]] <= (Q3 + 1.5 * IQR))
    }
  }
  return(df)
}

model_data <- remove_outliers(model_data)

# Replace outliers with NA
model_data <- na.omit(model_data)

model_data <- model_data[!duplicated(model_data), ]

# Split the data into training and testing sets
set.seed(123)
trainIndex <- createDataPartition(model_data$Velocity, p = .8, 
                                  list = FALSE, 
                                  times = 1)
train_data <- model_data[ trainIndex,]
test_data <- model_data[-trainIndex,]

# Tune the random forest model
tuneGrid <- expand.grid(mtry = c(5, 7, 9, 11))
train_control <- trainControl(method = "cv", number = 5)
rf_tuned <- train(Velocity ~ ., data = train_data, method = "rf", 
                  trControl = train_control, tuneGrid = tuneGrid)

# Print the best model
print(rf_tuned)

# Predict on the test set
predictions <- predict(rf_tuned, test_data)
test_rmse <- sqrt(mean((predictions - test_data$Velocity)^2))
print(paste("Test RMSE:", test_rmse))

# Define the ideal ranges for each x_value
ideal_ranges <- list(
  "Max_Pelvis_Rotational_Velocity" = c(NA, NA), "FC_to_Pelvis_Timing" = c(5, 20), 
  "Max_Trunk_Rotational_Velocity" = c(1100, Inf), "Pelvis_to_Trunk_Timing" = c(30, 50),
  "Max_Elbow_Extension_Velocity" = c(2100, Inf), "Trunk_to_Elbow_Timing" = c(NA, NA), 
  "Max_Shoulder_Rotational_Velocity" = c(4000, Inf), "Elbow_to_Shoulder_Timing" = c(NA, NA), 
  "Shoulder_to_BR_Timing" = c(-5, 5), "Stride_Length_Percent" = c(NA, NA), 
  "Stride_Width_IN" = c(-6, 6), "Max_COG_Velo" = c(110, Inf), "Trunk_Rotation" = c(-125, -100), 
  "Pelvis_Rotation" = c(-65, -40), "Hip_Shoulder_Separation" = c(30, 70), 
  "HSS_to_FC_Timing" = c(-70, -10), "Forward_Trunk_Tilt" = c(-16, -5), "Trunk_Lean" = c(3, 10), 
  "Lead_Knee_Flexion_FC" = c(40, 50), "Lead_Knee_Flexion_MER_delta" = c(-30, 2), "Lead_Knee_Flexion_MER" = c(NA,NA),
  "Lead_Knee_Flexion_BR" = c(NA,NA),"Lead_Knee_Flexion_BR_delta" = c(-Inf,-10), "Lead_Knee_Extension_Velo_Max" = c(-700, -350), 
  "Lead_Knee_Extension_Velo_Max_to_BR_Timing" = c(-70, 10), "Shoulder_Rotation_FC" = c(35, 75), 
  "Shoulder_Horz_Abduction_FC" = c(-55, -25), "Elbow_Flexion_FC" = c(90, 120), 
  "Shoulder_Rotation_MER" = c(170, 190), "Shoulder_Horz_Abduction_MER" = c(-Inf, 0), 
  "Max_Shoulder_Horz_Abduction_to_FC_Timing" = c(10, 65), "On_Plane_Percentage" = c(80, Inf), 
  "Elbow_Flextion_Inside_90_FC_to_BR" = c(68, 100)
)

new_ideal_ranges <- list(
  "Max_Pelvis_Rotational_Velocity" = c(NA, NA), "FC_to_Pelvis_Timing" = c(5, 40), 
  "Max_Trunk_Rotational_Velocity" = c(1050, Inf), "Pelvis_to_Trunk_Timing" = c(0, 31),
  "Max_Elbow_Extension_Velocity" = c(2000, Inf), "Trunk_to_Elbow_Timing" = c(NA, NA), 
  "Max_Shoulder_Rotational_Velocity" = c(NA, NA), "Elbow_to_Shoulder_Timing" = c(NA, NA), 
  "Shoulder_to_BR_Timing" = c(4, 10), "Stride_Length_Percent" = c(NA, NA), 
  "Stride_Width_IN" = c(-3, 9), "Max_COG_Velo" = c(100, Inf), "Trunk_Rotation" = c(NA, NA), 
  "Pelvis_Rotation" = c(-Inf, -70), "Hip_Shoulder_Separation" = c(NA, NA), 
  "HSS_to_FC_Timing" = c(-20, 30), "Forward_Trunk_Tilt" = c(-25, -10), "Trunk_Lean" = c(-3, 10.1), 
  "Lead_Knee_Flexion_FC" = c(51, 60), "Lead_Knee_Flexion_MER_delta" = c(-25, 0), "Lead_Knee_Flexion_MER" = c(NA,NA),
  "Lead_Knee_Flexion_BR" = c(NA,NA),"Lead_Knee_Flexion_BR_delta" = c(-Inf,-5), "Lead_Knee_Extension_Velo_Max" = c(-Inf, -450), 
  "Lead_Knee_Extension_Velo_Max_to_BR_Timing" = c(NA, NA), "Shoulder_Rotation_FC" = c(34, 85), 
  "Shoulder_Horz_Abduction_FC" = c(NA, NA), "Elbow_Flexion_FC" = c(70, 100), 
  "Shoulder_Rotation_MER" = c(170, 190), "Shoulder_Horz_Abduction_MER" = c(NA, NA), 
  "Max_Shoulder_Horz_Abduction_to_FC_Timing" = c(NA, NA), "On_Plane_Percentage" = c(25, 60), 
  "Elbow_Flextion_Inside_90_FC_to_BR" = c(NA, NA)
)

# Define the folder to save the plots
output_folder <- "C:/Users/benne/OneDrive/Documents/P3Work/p3_summer_2024/Bennett/Kina+Trackman+Assessment/BioMechGraphs/Over80GraphsRandomForest"
dir.create(output_folder, showWarnings = FALSE)

# Generate partial dependence plots for each x_value with vertical lines and save them
for (var in colnames(x_values)) {
  pdp <- partial(rf_tuned, pred.var = var, plot = FALSE, train = as.matrix(model_data %>% select(-Velocity)))
  pdp_plot <- autoplot(pdp) + 
    ggtitle(paste("Dependence of", var, "on Velocity: Random Forest")) +
    ylab("Predicted Fastball Velocity")
  
  # Add vertical lines if the range is specified and not NA
  if (!is.null(ideal_ranges[[var]]) && !is.na(ideal_ranges[[var]][1])) {
    pdp_plot <- pdp_plot + 
      geom_vline(xintercept = ideal_ranges[[var]][1], linetype = "dashed", color = "red")
  }
  if (!is.null(ideal_ranges[[var]]) && !is.na(ideal_ranges[[var]][2])) {
    pdp_plot <- pdp_plot + 
      geom_vline(xintercept = ideal_ranges[[var]][2], linetype = "dashed", color = "red")
  }
  
  if (!is.null(new_ideal_ranges[[var]]) && !is.na(new_ideal_ranges[[var]][1])) {
    pdp_plot <- pdp_plot + 
      geom_vline(xintercept = new_ideal_ranges[[var]][1], linetype = "dashed", color = "blue")
  }
  if (!is.null(new_ideal_ranges[[var]]) && !is.na(new_ideal_ranges[[var]][2])) {
    pdp_plot <- pdp_plot + 
      geom_vline(xintercept = new_ideal_ranges[[var]][2], linetype = "dashed", color = "blue")
  }
  
  print(pdp_plot)
  # Save the plot
  ggsave(filename = paste0(output_folder, "/", var, ".png"), plot = pdp_plot)
}
