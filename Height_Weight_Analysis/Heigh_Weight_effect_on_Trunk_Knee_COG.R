suppressWarnings(library(dplyr))
suppressWarnings(library(ggplot2))

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
  select(firstname, lastname, release_speed, MTRV, Lead_Knee_Ang_Vel_Max, Max_COM_AP_Vel)


weights <- read.csv("assessment_data_post_July_2022.csv") %>%
  select(firstname, lastname, bodyweight)

# Remove outliers and then calculate averages
pitch_avgs <- pitches %>%
  group_by(firstname, lastname) %>%
  summarize(
    AVG_FB_VELO = mean(remove_outliers(release_speed), na.rm = TRUE),
    MAX_TRUNK_ROTATIONAL_VELO = mean(remove_outliers(MTRV), na.rm = TRUE),
    LEAD_KNEE_EXTENSION_VELO = mean(remove_outliers(Lead_Knee_Ang_Vel_Max), na.rm = TRUE),
    MAX_COG_VELO = mean(remove_outliers(Max_COM_AP_Vel), na.rm = TRUE)
  )

avgs <- inner_join(pitch_avgs, weights, by = c("firstname", "lastname"))

avgs <- avgs %>% filter(!is.na(bodyweight))


degree <- 3

# Model 1: Predict AVG_FB_VELO using HEIGHT and WEIGHT
model1 <- lm(AVG_FB_VELO ~ poly(MAX_TRUNK_ROTATIONAL_VELO, degree) + poly(WEIGHT, degree), data = avgs)

# Model 2: Polynomial model with LEAD_KNEE_EXTENSION_VELO and WEIGHT
model2 <- lm(AVG_FB_VELO ~ poly(LEAD_KNEE_EXTENSION_VELO, degree) + poly(WEIGHT, degree), data = avgs)

# Model 3: Polynomial model with MAX_COG_VELO and WEIGHT
model3 <- lm(AVG_FB_VELO ~ poly(MAX_COG_VELO, degree) + poly(WEIGHT, degree), data = avgs)

model4 <- lm(MAX_TRUNK_ROTATIONAL_VELO ~ poly(AVG_FB_VELO,degree) + poly(WEIGHT, degree), data = avgs)

summary(model4)

# Create a new data frame for the prediction
new_data <- data.frame(AVG_FB_VELO = 90, WEIGHT = 240)

# Make the prediction
prediction <- predict(model4, newdata = new_data)

# Print the predicted value
prediction

# Print model summaries
summary(model1)
summary(model2)
summary(model3)

# Make predictions
avgs$pred1 <- predict(model1, newdata = avgs)
avgs$pred2 <- predict(model2, newdata = avgs)
avgs$pred3 <- predict(model3, newdata = avgs)

#Find Correlations between Predicted and Actual
model1_Cor <- cor(avgs$AVG_FB_VELO, avgs$pred1)
model2_Cor <- cor(avgs$AVG_FB_VELO, avgs$pred2)
model3_Cor <- cor(avgs$AVG_FB_VELO, avgs$pred3)

print(paste("Model 1 Correlation: ", round(model1_Cor, 2)))
print(paste("Model 2 Correlation: ", round(model2_Cor, 2)))
print(paste("Model 3 Correlation: ", round(model3_Cor, 2)))

# Plot for Model 1
plot1 <- ggplot(avgs, aes(x = pred1, y = AVG_FB_VELO)) +
  geom_point(aes(color = WEIGHT), size = 3) +
  geom_abline(intercept = 0, slope = 1, color = "red", linetype = "dashed") +
  labs(title = "Model 1: Predicted vs. Actual AVG_FB_VELO",
       x = "Predicted Velocity (mph)",
       y = "Actual Velocity (mph)") +
  theme_minimal()

# Plot for Model 2
plot2 <- ggplot(avgs, aes(x = pred2, y = AVG_FB_VELO)) +
  geom_point(aes(color = WEIGHT), size = 3) +
  geom_abline(intercept = 0, slope = 1, color = "red", linetype = "dashed") +
  labs(title = "Model 2: Predicted vs. Actual AVG_FB_VELO",
       x = "Predicted Velocity (mph)",
       y = "Actual Velocity (mph)") +
  theme_minimal()

# Plot for Model 3
plot3 <- ggplot(avgs, aes(x = pred3, y = AVG_FB_VELO)) +
  geom_point(aes(color = WEIGHT), size = 3) +
  geom_abline(intercept = 0, slope = 1, color = "red", linetype = "dashed") +
  labs(title = "Model 3: Predicted vs. Actual AVG_FB_VELO",
       x = "Predicted Velocity (mph)",
       y = "Actual Velocity (mph)") +
  theme_minimal()

# Print plots
print(plot1)
print(plot2)
print(plot3)

