# Load Packages
library(dplyr)


# Load in assement data and pitch velocity data
assessment_data <- read.csv("assessment_data_post_July_2022.csv")

# Select the columns you want to keep (adjust this list as necessary)
columns_to_keep <- c("firstname", "lastname","throwing.side","X10.year.sprint.seconds.laser", "ankle.dorsiflexion.left",
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
cleaned_data <- assessment_data %>% select(all_of(columns_to_keep))

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




# Write the cleaned data with percentiles to a new CSV file
write.csv(cleaned_data, "cleaned_assessment_data.csv", row.names = FALSE)


