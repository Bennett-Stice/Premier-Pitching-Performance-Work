library(dplyr)
library(ggplot2)


# Function to remove outliers based on IQR method
remove_outliers <- function(data) {
  num_cols <- data %>% select(where(is.numeric))
  for (col in colnames(num_cols)) {
    Q1 <- quantile(data[[col]], 0.25, na.rm = TRUE)
    Q3 <- quantile(data[[col]], 0.75, na.rm = TRUE)
    IQR <- Q3 - Q1
    lower_bound <- Q1 - 1.5 * IQR
    upper_bound <- Q3 + 1.5 * IQR
    data <- data %>% filter((data[[col]] >= lower_bound) & (data[[col]] <= upper_bound) | is.na(data[[col]]))
  }
  return(data)
}

BioMechPitches <- read.csv("Boost_BioMech_Metrics_And_Velos_greater_than_80.csv")
AssessmentData <- read.csv("cleaned_assessment_data.csv")

BioMechPitches <- remove_outliers(BioMechPitches)


BioMechPitchAverage <- BioMechPitches %>%
  group_by(firstname, lastname) %>%
  summarise(across(where(is.numeric), mean, na.rm = TRUE))

CombinedData <- left_join(AssessmentData, BioMechPitchAverage, by = c("firstname", "lastname"))


write.csv(CombinedData, "BioMech_And_Assessment_Data.csv", row.names = FALSE)

numeric_columns <- CombinedData %>%
  select(where(is.numeric))

trunk_correlations <- numeric_columns %>%
  summarise(across(everything(), ~ cor(.x, numeric_columns$Max_Trunk_Rotational_Velo, use = "complete.obs")))

trunk_correlation_df <- data.frame(
  variable = colnames(trunk_correlations),
  correlation = as.numeric(trunk_correlations)
)

lead_knee_correlations <- numeric_columns %>%
  summarise(across(everything(), ~ cor(.x, numeric_columns$Lead_Knee_Extension_Velo_Max, use = "complete.obs")))

lead_knee_correlation_df <- data.frame(
  variable = colnames(lead_knee_correlations),
  correlation = as.numeric(lead_knee_correlations)
)

shoulder_correlations <- numeric_columns %>%
  summarise(across(everything(), ~ cor(.x, numeric_columns$Max_Shoulder_Rotational_Velocity, use = "complete.obs")))

shoulder_correlation_df <- data.frame(
  variable = colnames(shoulder_correlations),
  correlation = as.numeric(shoulder_correlations)
)

elbow_correlations <- numeric_columns %>%
  summarise(across(everything(), ~ cor(.x, numeric_columns$Max_Elbow_Extension_Velocity, use = "complete.obs")))

elbow_correlation_df <- data.frame(
  variable = colnames(elbow_correlations),
  correlation = as.numeric(elbow_correlations)
)

COG_correlations <- numeric_columns %>%
  summarise(across(everything(), ~ cor(.x, numeric_columns$Max_COG_Velo , use = "complete.obs")))

COG_correlation_df <- data.frame(
  variable = colnames(COG_correlations),
  correlation = as.numeric(COG_correlations)
)

velocity_correlations <- numeric_columns %>%
  summarise(across(everything(), ~ cor(.x, numeric_columns$Velocity , use = "complete.obs")))

velocity_correlation_df <- data.frame(
  variable = colnames(velocity_correlations),
  correlation = as.numeric(velocity_correlations)
)

ggplot(CombinedData, aes(x = Max_Trunk_Rotational_Velocity, y = Velocity)) +
  geom_point(color = "blue") + # Scatter plot
  geom_smooth(method = "lm", se = FALSE, color = "red") + # Regression line
  labs(
    title = "Max Trunk Rotational vs AVG FB Velocity",
    x = "Max Trunk Rotational Velocity",
    y = "AVG FB Velocity"
  ) +
  theme_minimal() # Clean theme

ggplot(CombinedData, aes(x = Lead_Knee_Extension_Velo_Max, y = Velocity)) +
  geom_point(color = "blue") + # Scatter plot
  geom_smooth(method = "lm", se = FALSE, color = "red") + # Regression line
  labs(
    title = "Lead Knee Extention Velocity Max vs AVG FB Velocity",
    x = "Lead Knee Extention Velocity",
    y = "AVG FB Velocity"
  ) +
  theme_minimal() # Clean theme

ggplot(CombinedData, aes(x = Max_Shoulder_Rotational_Velocity, y = Velocity)) +
  geom_point(color = "blue") + # Scatter plot
  geom_smooth(method = "lm", se = FALSE, color = "red") + # Regression line
  labs(
    title = "Max Shoulder Rotational Velocity vs AVG FB Velocity",
    x = "Max Shoulder Rotational Velocity",
    y = "AVG FB Velocity"
  ) +
  theme_minimal() # Clean theme

ggplot(CombinedData, aes(x = Max_Elbow_Extension_Velocity, y = Velocity)) +
  geom_point(color = "blue") + # Scatter plot
  geom_smooth(method = "lm", se = FALSE, color = "red") + # Regression line
  labs(
    title = "Max Elbow Extention Velocity vs AVG FB Velocity",
    x = "Max Elbow Extention Velocity",
    y = "AVG FB Velocity"
  ) +
  theme_minimal() # Clean theme

ggplot(CombinedData, aes(x = Max_COG_Velo, y = Velocity)) +
  geom_point(color = "blue") + # Scatter plot
  geom_smooth(method = "lm", se = FALSE, color = "red") + # Regression line
  labs(
    title = "Max COG Velocity vs AVG FB Velocity",
    x = "Max COG Velocity",
    y = "AVG FB Velocity"
  ) +
  theme_minimal() # Clean theme

ggplot(CombinedData, aes(x = shoulder.total.range.non.throwing, y = Velocity)) +
  geom_point(color = "blue") + # Scatter plot
  geom_smooth(method = "lm", se = FALSE, color = "red") + # Regression line
  labs(
    title = "Non Throwing Shoulder Total Range vs AVG FB Velocity",
    x = "Non Throwing Shoulder Total Range",
    y = "AVG FB Velocity"
  ) +
  theme_minimal() # Clean theme

ggplot(CombinedData, aes(x = shoulder.prone.active.er.non.throwing, y = Velocity)) +
  geom_point(color = "blue") + # Scatter plot
  geom_smooth(method = "lm", se = FALSE, color = "red") + # Regression line
  labs(
    title = "Non Throwing Shoulder External Rotation vs AVG FB Velocity",
    x = "Non Throwing Shoulder External Rotation",
    y = "AVG FB Velocity"
  ) +
  theme_minimal() # Clean theme

ggplot(CombinedData, aes(x = shoulder.internal.rotation.non.throwing, y = Velocity)) +
  geom_point(color = "blue") + # Scatter plot
  geom_smooth(method = "lm", se = FALSE, color = "red") + # Regression line
  labs(
    title = "Non Throwing Shoulder Internal Rotation vs AVG FB Velocity",
    x = "Non Throwing Shoulder Internal Rotation",
    y = "AVG FB Velocity"
  ) +
  theme_minimal() # Clean theme

ggplot(CombinedData, aes(x = shoulder.horizontal.abduction.non.throwing, y = Velocity)) +
  geom_point(color = "blue") + # Scatter plot
  geom_smooth(method = "lm", se = FALSE, color = "red") + # Regression line
  labs(
    title = "Non Throwing Shoulder Horz Abduction vs AVG FB Velocity",
    x = "Non Throwing Shoulder Horz Abduction",
    y = "AVG FB Velocity"
  ) +
  theme_minimal() # Clean theme

ggplot(CombinedData, aes(x = shoulder.flexion.scap.stabilized.non.throwing, y = Velocity)) +
  geom_point(color = "blue") + # Scatter plot
  geom_smooth(method = "lm", se = FALSE, color = "red") + # Regression line
  labs(
    title = "Non Throwing Shoulder Flexion Scap Stabilized vs AVG FB Velocity",
    x = "Non Throwing Shoulder Flexion Scap Stabilized",
    y = "AVG FB Velocity"
  ) +
  theme_minimal() # Clean theme

ggplot(CombinedData, aes(x = shoulder.flexion.non.throwing, y = Velocity)) +
  geom_point(color = "blue") + # Scatter plot
  geom_smooth(method = "lm", se = FALSE, color = "red") + # Regression line
  labs(
    title = "Non Throwing Shoulder Flexion vs AVG FB Velocity",
    x = "Non Throwing Shoulder Flexion",
    y = "AVG FB Velocity"
  ) +
  theme_minimal() # Clean theme

