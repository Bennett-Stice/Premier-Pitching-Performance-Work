# Load Packages
library(fastDummies)
library(dplyr)
library(randomForest)
library(xgboost)
library(Boruta)
library(caret)

# Load in assessment data and pitch velocity data
assessment_data <- read.csv("assessment_data.csv")
avg_max_fb_velo <- read.csv("trackman_pitcher_avg_max_FB_velo.csv")


combined_data <- inner_join(assessment_data, avg_max_fb_velo, by = c("firstname", "lastname"))

names_throwing_side_and_velos <- c("firstname", "lastname", "throwing.side", "avgfastballvelo","maxfastballvelo")

categorical_values <- c("cervical.active.rom.extension","cervical.active.rom.flexion",
                     "cervical.active.rom.left.rotation", "cervical.active.rom.right.rotation", "elbow.extension.left",
                     "elbow.extension.right", "hip.bias.left", "hip.bias.right", "hip.hamstring.left", "hip.hamstring.right",
                     "hip.prone.quad.length.left", "hip.prone.quad.length.right", "hip.rotational.arc.left","hip.rotational.arc.right",
                     "hip.thomas.test.left","hip.thomas.test.right","movement.standing.flexion","scap.eval.0deg.left","scap.eval.0deg.right",
                     "scap.eval.90deg.left","scap.eval.90deg.right","side.step.walkout","spine.cervical",
                     "spine.lumbar","spine.thoracic","strided.extension.left.forward","strided.extension.right.forward","thoracic.rotation.left",
                     "thoracic.rotation.right","barbell.rdl","front.squat","lateral.lunge.left","lateral.lunge.right","pushup","reverse.lunge.left",
                     "reverse.lunge.right")


numeric_values <- c("X10.year.sprint.seconds.laser", "ankle.dorsiflexion.throwing",
                     "ankle.dorsiflexion.non.throwing","bodyweight","broad.jump.inches","cmj.jump.height.cm","cmj.peak.force.n", "imtp.peak.force.n",
                     "dynamic.strength.index","eccentric.utilization.ratio","single.leg.lateral.jump.inches.throwing","single.leg.lateral.jump.inches.non.throwing",
                     "squat.jump.height.cm","grip.strength.throwing","grip.strength.non.throwing","hip.prone.external.rotation.throwing",
                     "hip.prone.external.rotation.non.throwing", "hip.prone.internal.rotation.throwing","hip.prone.internal.rotation.non.throwing",
                     "hip.seated.external.rotation.90.throwing", "hip.seated.external.rotation.90.non.throwing","hip.seated.internal.rotation.90.throwing",
                     "hip.seated.internal.rotation.90.non.throwing", "medball.throws.overhead.throw.4lb.mph", "medball.throws.scoop.throw.6lb.mph",
                     "medball.throws.shotput.toss.6lb.mph","shoulder.flexion.throwing","shoulder.flexion.non.throwing","shoulder.flexion.scap.stabilized.throwing",
                     "shoulder.flexion.scap.stabilized.non.throwing","shoulder.horizontal.abduction.throwing","shoulder.horizontal.abduction.non.throwing",
                     "shoulder.internal.rotation.throwing","shoulder.internal.rotation.non.throwing","shoulder.prone.active.er.throwing", "shoulder.prone.active.er.non.throwing",
                     "shoulder.total.range.throwing","shoulder.total.range.non.throwing")

columns_to_keep <- c("firstname", "lastname", "throwing.side", "avgfastballvelo","maxfastballvelo", "cervical.active.rom.extension","cervical.active.rom.flexion",
                     "cervical.active.rom.left.rotation", "cervical.active.rom.right.rotation", "elbow.extension.left",
                     "elbow.extension.right", "hip.bias.left", "hip.bias.right", "hip.hamstring.left", "hip.hamstring.right",
                     "hip.prone.quad.length.left", "hip.prone.quad.length.right", "hip.rotational.arc.left","hip.rotational.arc.right",
                     "hip.thomas.test.left","hip.thomas.test.right","movement.standing.flexion","scap.eval.0deg.left","scap.eval.0deg.right",
                     "scap.eval.90deg.left","scap.eval.90deg.right","side.step.walkout","spine.cervical",
                     "spine.lumbar","spine.thoracic","strided.extension.left.forward","strided.extension.right.forward","thoracic.rotation.left",
                     "thoracic.rotation.right","barbell.rdl","front.squat","lateral.lunge.left","lateral.lunge.right","pushup","reverse.lunge.left",
                     "reverse.lunge.right", "X10.year.sprint.seconds.laser", "ankle.dorsiflexion.left",
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
    shoulder.total.range.non.throwing = if_else(throwing.side == "Left", shoulder.total.range.right, shoulder.total.range.left),
 
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
    hip.rotational.arc.non.throwing = if_else(throwing.side == "Left", hip.rotational.arc.right, hip.rotational.arc.left),
    
    hip.thomas.test.throwing = if_else(throwing.side == "Left", hip.thomas.test.left, hip.thomas.test.right),
    hip.thomas.test.non.throwing = if_else(throwing.side == "Left", hip.thomas.test.right, hip.thomas.test.left),
    
    scap.eval.0deg.throwing = if_else(throwing.side == "Left", scap.eval.0deg.left, scap.eval.0deg.right),
    scap.eval.0deg.non.throwing = if_else(throwing.side == "Left", scap.eval.0deg.right, scap.eval.0deg.left),
    
    scap.eval.90deg.throwing = if_else(throwing.side == "Left", scap.eval.90deg.left, scap.eval.90deg.right),
    scap.eval.90deg.non.throwing = if_else(throwing.side == "Left", scap.eval.90deg.right, scap.eval.90deg.left),
    
    strided.extension.forward.throwing = if_else(throwing.side == "Left", strided.extension.left.forward, strided.extension.right.forward),
    strided.extension.forward.non.throwing = if_else(throwing.side == "Left", strided.extension.right.forward, strided.extension.left.forward),
    
    thoracic.rotation.throwing = if_else(throwing.side == "Left", thoracic.rotation.left, thoracic.rotation.right),
    thoracic.rotation.non.throwing = if_else(throwing.side == "Left", thoracic.rotation.right, thoracic.rotation.left),
    
    lateral.lunge.throwing = if_else(throwing.side == "Left", lateral.lunge.left, lateral.lunge.right),
    lateral.lunge.non.throwing = if_else(throwing.side == "Left", lateral.lunge.right, lateral.lunge.left),
    
    reverse.lunge.throwing = if_else(throwing.side == "Left", reverse.lunge.left, reverse.lunge.right),
    reverse.lunge.non.throwing = if_else(throwing.side == "Left", reverse.lunge.right, reverse.lunge.left)
 )



# Remove the original .left and .right columns
cleaned_data <- cleaned_data %>%
  select(-ends_with(".left"), -ends_with(".right"), -strided.extension.left.forward, -strided.extension.right.forward, -cervical.active.rom.left.rotation, -cervical.active.rom.right.rotation)


# Identify categorical columns
categorical_columns <- c("cervical.active.rom.rotation.throwing","cervical.active.rom.rotation.non.throwing",
                         "elbow.extension.throwing","elbow.extension.non.throwing","hip.bias.throwing",
                         "hip.bias.non.throwing","hip.hamstring.throwing","hip.hamstring.non.throwing",
                         "hip.prone.quad.length.throwing","hip.prone.quad.length.non.throwing","hip.rotational.arc.throwing",
                         "hip.rotational.arc.non.throwing","hip.thomas.test.throwing","hip.thomas.test.non.throwing",
                         "scap.eval.0deg.throwing","scap.eval.0deg.non.throwing","scap.eval.90deg.throwing","scap.eval.90deg.non.throwing",
                         "thoracic.rotation.throwing","thoracic.rotation.non.throwing","strided.extension.forward.throwing",
                         "strided.extension.forward.non.throwing","lateral.lunge.throwing","lateral.lunge.non.throwing",
                         "reverse.lunge.throwing","cervical.active.rom.extension","cervical.active.rom.flexion",
                         "movement.standing.flexion","side.step.walkout","spine.cervical","spine.lumbar","spine.thoracic",
                         "barbell.rdl","front.squat","pushup")



# Encode categorical data
encoded_data <- dummy_cols(cleaned_data, select_columns = categorical_columns, remove_selected_columns = TRUE)

cleaned_data <- cleaned_data %>%
  select(-all_of(categorical_columns))

# Combine encoded_data and cleaned_data
final_data <- encoded_data %>% 
  select(-firstname, -lastname,-throwing.side, -maxfastballvelo) %>% 
  bind_cols(cleaned_data %>% select(-firstname, -lastname, -throwing.side,-avgfastballvelo, -maxfastballvelo))

# Split the data into training and testing sets
set.seed(42)  # For reproducibility
trainIndex <- createDataPartition(final_data$avgfastballvelo, p = .8, 
                                  list = FALSE, 
                                  times = 1)

train_data <- final_data[trainIndex,]
test_data <- final_data[-trainIndex,]

# Prepare the data for XGBoost
train_matrix <- xgb.DMatrix(data = as.matrix(train_data %>% select(-avgfastballvelo)), label = train_data$avgfastballvelo)
test_matrix <- xgb.DMatrix(data = as.matrix(test_data %>% select(-avgfastballvelo)), label = test_data$avgfastballvelo)

# Convert data to matrix format
x <- as.matrix(train_data %>% select(-avgfastballvelo))
y <- train_data$avgfastballvelo

# Define the parameter grid for tuning
param_grid <- expand.grid(
  nrounds = sample(800:1200, 10),  # Randomly sample nrounds between 800 and 1200
  eta = runif(10, 0.01, 0.5),       # Uniform distribution for eta between 0.01 and 0.5
  max_depth = sample(3:9, 5),       # Randomly sample max_depth between 3 and 9
  gamma = runif(5, 0, 0.2),         # Uniform distribution for gamma between 0 and 0.2
  min_child_weight = sample(c(1, 5, 10), 3),  # Sample from specified values for min_child_weight
  subsample = runif(5, 0.6, 1.0),   # Uniform distribution for subsample between 0.6 and 1.0
  colsample_bytree = runif(5, 0.6, 1.0)  # Uniform distribution for colsample_bytree between 0.6 and 1.0
)

# Limit param_grid to 200 combinations if it exceeds
param_grid <- param_grid[sample(nrow(param_grid), min(100, nrow(param_grid))), ]

# Set up repeated cross-validation
ctrl <- trainControl(
  method = "cv",
  number = 2,
  verboseIter = TRUE
)

# Train the XGBoost model with hyperparameter tuning
xgb_tune <- train(
  x = as.matrix(train_data %>% select(-avgfastballvelo)),
  y = train_data$avgfastballvelo,
  trControl = ctrl,
  tuneGrid = param_grid,
  method = "xgbTree",
  metric = "RMSE",  # Use RMSE as the metric for evaluation
  nthread = 3  # Number of threads to use for parallel processing
)

# Print the best parameters and model performance
print(xgb_tune)


# 1. Generate predictions
predictions <- predict(xgb_tune, newdata = test_data %>% select(-avgfastballvelo))

# 2. Calculate RMSE
rmse <- sqrt(mean((test_data$avgfastballvelo - predictions)^2))
mae <- mean(abs(test_data$avgfastballvelo - predictions))

# 3. Calculate R-squared
actual_mean <- mean(test_data$avgfastballvelo)
ss_total <- sum((test_data$avgfastballvelo - actual_mean)^2)
ss_residual <- sum((test_data$avgfastballvelo - predictions)^2)
rsquared <- 1 - (ss_residual / ss_total)

# Print RMSE and R-squared
cat("RMSE:", rmse, "\n")
cat("MAE:",mae, "\n")
cat("R-squared:", rsquared, "\n")



# Set the parameters for the XGBoost model
params <- list(
  booster = "gbtree",
  objective = "reg:squarederror",
  eta = 0.1,
  max_depth = 6,
  subsample = 0.8,
  colsample_bytree = 0.8
)

# Train the XGBoost model
xgb_model <- xgb.train(
  params = params,
  data = train_matrix,
  nrounds = 100,
  watchlist = list(train = train_matrix, test = test_matrix),
  early_stopping_rounds = 10,
  print_every_n = 10
)

# Evaluate the model's performance
predictions <- predict(xgb_model, test_matrix)
rmse <- sqrt(mean((predictions - test_data$avgfastballvelo)^2))
print(paste("RMSE on test set:", rmse))


# 2. Calculate RMSE
rmse <- sqrt(mean((test_data$avgfastballvelo - predictions)^2))
mae <- mean(abs(test_data$avgfastballvelo - predictions))

# 3. Calculate R-squared
actual_mean <- mean(test_data$avgfastballvelo)
ss_total <- sum((test_data$avgfastballvelo - actual_mean)^2)
ss_residual <- sum((test_data$avgfastballvelo - predictions)^2)
rsquared <- 1 - (ss_residual / ss_total)

# Print RMSE and R-squared
cat("RMSE:", rmse, "\n")
cat("MAE:",mae, "\n")
cat("R-squared:", rsquared, "\n")
