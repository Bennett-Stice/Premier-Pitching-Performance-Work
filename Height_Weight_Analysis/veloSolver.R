# Load necessary libraries
suppressWarnings(library(dplyr))
suppressWarnings(library(ggplot2))
suppressWarnings(library(xgboost))
suppressWarnings(library(mgcv))    # For GAM
suppressWarnings(library(e1071))   # For SVM
suppressWarnings(library(randomForest))
suppressWarnings(library(Metrics))  # For RMSE

# Function to remove outliers based on IQR
remove_outliers <- function(x) {
  Q1 <- quantile(x, 0.25, na.rm = TRUE)
  Q3 <- quantile(x, 0.75, na.rm = TRUE)
  IQR <- Q3 - Q1
  lower_bound <- Q1 - 1.5 * IQR
  upper_bound <- Q3 + 1.5 * IQR
  x[x >= lower_bound & x <= upper_bound]
}

pitches <- read.csv("Kinatrax+Trackman_over80.csv") %>%
  select(firstname, lastname, release_speed, MTRV, Lead_Knee_Ang_Vel_Max, Max_COM_AP_Vel, MPRV)


weights <- read.csv("assessment_data_post_July_2022.csv") %>%
  select(firstname, lastname, bodyweight)

# Remove outliers and then calculate averages
pitch_avgs <- pitches %>%
  group_by(firstname, lastname) %>%
  summarize(
    AVG_FB_VELO = mean(remove_outliers(release_speed), na.rm = TRUE),
    MAX_TRUNK_ROTATIONAL_VELO = mean(remove_outliers(MTRV), na.rm = TRUE),
    LEAD_KNEE_EXTENSION_VELO = mean(remove_outliers(Lead_Knee_Ang_Vel_Max), na.rm = TRUE),
    MAX_COG_VELO = mean(remove_outliers(Max_COM_AP_Vel), na.rm = TRUE),
    MAX_PELVIS_ROTATIONAL_VELO = mean(remove_outliers(MPRV), na.rm = TRUE)
  )

avgs <- inner_join(pitch_avgs, weights, by = c("firstname", "lastname"))

avgs <- avgs %>% filter(!is.na(bodyweight))
avgs <- avgs %>% rename(WEIGHT = bodyweight)



# Linear model as a baseline
linearModel <- lm(MAX_PELVIS_ROTATIONAL_VELO ~ poly(AVG_FB_VELO, 3) + poly(WEIGHT, 3), data = avgs)

# Create a sequence of WEIGHT values from 150 to 250 for predictions
weight_values <- seq(150, 250, by = 1)
prediction_data <- data.frame(AVG_FB_VELO = 85, WEIGHT = weight_values)

# XGBoost Model
train_matrix <- as.matrix(avgs[, c("AVG_FB_VELO", "WEIGHT")])
label <- avgs$MAX_PELVIS_ROTATIONAL_VELO
xgb_model <- xgboost(data = train_matrix, label = label, nrounds = 100, objective = "reg:squarederror")
pred_xgb <- predict(xgb_model, newdata = as.matrix(prediction_data[, c("AVG_FB_VELO", "WEIGHT")]))
rsq_xgb <- 1 - sum((label - predict(xgb_model, newdata = train_matrix))^2) / sum((label - mean(label))^2)
rmse_xgb <- rmse(label, predict(xgb_model, newdata = train_matrix))

# GAM Model
gam_model <- gam(MAX_PELVIS_ROTATIONAL_VELO ~ s(AVG_FB_VELO, bs = "cs") + s(WEIGHT, bs = "cs"), data = avgs)
pred_gam <- predict(gam_model, newdata = prediction_data)
rsq_gam <- 1 - sum((avgs$MAX_PELVIS_ROTATIONAL_VELO - predict(gam_model, newdata = avgs))^2) / sum((avgs$MAX_PELVIS_ROTATIONAL_VELO - mean(avgs$MAX_PELVIS_ROTATIONAL_VELO))^2)
rmse_gam <- rmse(avgs$MAX_PELVIS_ROTATIONAL_VELO, predict(gam_model, newdata = avgs))

# SVM Model
svm_model <- svm(MAX_PELVIS_ROTATIONAL_VELO ~ AVG_FB_VELO + WEIGHT, data = avgs)
pred_svm <- predict(svm_model, newdata = prediction_data)
rsq_svm <- 1 - sum((avgs$MAX_PELVIS_ROTATIONAL_VELO - predict(svm_model, newdata = avgs))^2) / sum((avgs$MAX_PELVIS_ROTATIONAL_VELO - mean(avgs$MAX_PELVIS_ROTATIONAL_VELO))^2)
rmse_svm <- rmse(avgs$MAX_PELVIS_ROTATIONAL_VELO, predict(svm_model, newdata = avgs))

# Random Forest Model
rf_model <- randomForest(MAX_PELVIS_ROTATIONAL_VELO ~ AVG_FB_VELO + WEIGHT, data = avgs, ntree = 100)
pred_rf <- predict(rf_model, newdata = prediction_data)
rsq_rf <- 1 - sum((avgs$MAX_PELVIS_ROTATIONAL_VELO - predict(rf_model, newdata = avgs))^2) / sum((avgs$MAX_PELVIS_ROTATIONAL_VELO - mean(avgs$MAX_PELVIS_ROTATIONAL_VELO))^2)
rmse_rf <- rmse(avgs$MAX_PELVIS_ROTATIONAL_VELO, predict(rf_model, newdata = avgs))

# Print R-squared and RMSE for each model
cat("XGBoost Model - R-squared:", rsq_xgb, "RMSE:", rmse_xgb, "\n")
cat("GAM Model - R-squared:", rsq_gam, "RMSE:", rmse_gam, "\n")
cat("SVM Model - R-squared:", rsq_svm, "RMSE:", rmse_svm, "\n")
cat("Random Forest Model - R-squared:", rsq_rf, "RMSE:", rmse_rf, "\n")

# Add predictions to the prediction_data dataframe
prediction_data$XGBoost <- pred_xgb
prediction_data$GAM <- pred_gam
prediction_data$SVM <- pred_svm
prediction_data$RandomForest <- pred_rf

# Plot XGBoost results
xgb_plot <- ggplot(prediction_data, aes(x = WEIGHT, y = XGBoost)) +
  geom_line(color = "red", linewidth = 1) +
  labs(title = "XGBoost Predicted MAX_PELVIS_ROTATIONAL_VELO vs. WEIGHT 85 mph",
       x = "Weight (lbs)",
       y = "Predicted MAX_PELVIS_ROTATIONAL_VELO")

# Plot GAM results
gam_plot <- ggplot(prediction_data, aes(x = WEIGHT, y = GAM)) +
  geom_line(color = "green", linewidth = 1) +
  labs(title = "GAM Predicted MAX_PELVIS_ROTATIONAL_VELO vs. WEIGHT 85 mph",
       x = "Weight (lbs)",
       y = "Predicted MAX_PELVIS_ROTATIONAL_VELO") 

# Plot SVM results
svm_plot <- ggplot(prediction_data, aes(x = WEIGHT, y = SVM)) +
  geom_line(color = "blue", linewidth = 1) +
  labs(title = "SVM Predicted MAX_PELVIS_ROTATIONAL_VELO vs. WEIGHT 85 mph",
       x = "Weight (lbs)",
       y = "Predicted MAX_PELVIS_ROTATIONAL_VELO") 

# Plot Random Forest results
rf_plot <- ggplot(prediction_data, aes(x = WEIGHT, y = RandomForest)) +
  geom_line(color = "purple", linewidth = 1) +
  labs(title = "Random Forest Predicted MAX_PELVIS_ROTATIONAL_VELO vs. WEIGHT 85 mph",
       x = "Weight (lbs)",
       y = "Predicted MAX_PELVIS_ROTATIONAL_VELO") 

print(xgb_plot)
print(gam_plot)
print(svm_plot)
print(rf_plot)

output_folder <- "C:/Users/benne/OneDrive/Documents/P3Work/p3_summer_2024/Bennett/Height_Weight_Analysis/Weight_Effect_Graphs/Max_Pelvis_Rotational_Velo/85mph"
dir_create(output_folder)

ggsave(filename = file.path(output_folder, paste0("XGBoost85mph.png")), plot = xgb_plot, width = 10, height = 6)
ggsave(filename = file.path(output_folder, paste0("GAM85mph.png")), plot = gam_plot, width = 10, height = 6)
ggsave(filename = file.path(output_folder, paste0("SVM85mph.png")), plot = svm_plot, width = 10, height = 6)
ggsave(filename = file.path(output_folder, paste0("RandomForest85mph.png")), plot = rf_plot, width = 10, height = 6)



