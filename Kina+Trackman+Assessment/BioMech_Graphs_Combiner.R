library(gridExtra)
library(png)
library(grid)
library(ggplot2)

# Define the folders
folders <- c(
  #"C:/Users/benne/OneDrive/Documents/P3Work/p3_summer_2024/Bennett/Kina+Trackman+Assessment/BioMechGraphs/Over80GraphsRandomForest",
 # "C:/Users/benne/OneDrive/Documents/P3Work/p3_summer_2024/Bennett/Kina+Trackman+Assessment/BioMechGraphs/Over85GraphsRandomForest",
#  "C:/Users/benne/OneDrive/Documents/P3Work/p3_summer_2024/Bennett/Kina+Trackman+Assessment/BioMechGraphs/Over90GraphsRandomForest",
#  "C:/Users/benne/OneDrive/Documents/P3Work/p3_summer_2024/Bennett/Kina+Trackman+Assessment/BioMechGraphs/Over95GraphsRandomForest",
  "C:/Users/benne/OneDrive/Documents/P3Work/p3_summer_2024/Bennett/Kina+Trackman+Assessment/BioMechGraphs/Over80GraphsXGBoost",
  "C:/Users/benne/OneDrive/Documents/P3Work/p3_summer_2024/Bennett/Kina+Trackman+Assessment/BioMechGraphs/Over85GraphsXGBoost",
  "C:/Users/benne/OneDrive/Documents/P3Work/p3_summer_2024/Bennett/Kina+Trackman+Assessment/BioMechGraphs/Over90GraphsXGBoost",
  "C:/Users/benne/OneDrive/Documents/P3Work/p3_summer_2024/Bennett/Kina+Trackman+Assessment/BioMechGraphs/Over95GraphsXGBoost",
  "C:/Users/benne/OneDrive/Documents/P3Work/p3_summer_2024/Bennett/Kina+Trackman+Assessment/BioMechGraphs/Over80GraphsGAM",
  "C:/Users/benne/OneDrive/Documents/P3Work/p3_summer_2024/Bennett/Kina+Trackman+Assessment/BioMechGraphs/Over85GraphsGAM",
  "C:/Users/benne/OneDrive/Documents/P3Work/p3_summer_2024/Bennett/Kina+Trackman+Assessment/BioMechGraphs/Over90GraphsGAM",
  "C:/Users/benne/OneDrive/Documents/P3Work/p3_summer_2024/Bennett/Kina+Trackman+Assessment/BioMechGraphs/Over95GraphsGAM"
  #"C:/Users/benne/OneDrive/Documents/P3Work/p3_summer_2024/Bennett/Kina+Trackman+Assessment/BioMechGraphs/Over80GraphsSVM",
  #"C:/Users/benne/OneDrive/Documents/P3Work/p3_summer_2024/Bennett/Kina+Trackman+Assessment/BioMechGraphs/Over85GraphsSVM",
  #"C:/Users/benne/OneDrive/Documents/P3Work/p3_summer_2024/Bennett/Kina+Trackman+Assessment/BioMechGraphs/Over90GraphsSVM",
  #"C:/Users/benne/OneDrive/Documents/P3Work/p3_summer_2024/Bennett/Kina+Trackman+Assessment/BioMechGraphs/Over95GraphsSVM"
)

# File names to be used in each page
file_names <- c(
  "Max_Pelvis_Rotational_Velocity", "FC_to_Pelvis_Timing", 
  "Max_Trunk_Rotational_Velocity", "Pelvis_to_Trunk_Timing",
  "Max_Elbow_Extension_Velocity", "Trunk_to_Elbow_Timing", 
  "Max_Shoulder_Rotational_Velocity", "Elbow_to_Shoulder_Timing", 
  "Shoulder_to_BR_Timing", "Stride_Length_Percent", 
  "Stride_Width_IN", "Max_COG_Velo", "Trunk_Rotation", 
  "Pelvis_Rotation", "Hip_Shoulder_Separation", 
  "HSS_to_FC_Timing", "Forward_Trunk_Tilt", "Trunk_Lean", 
  "Lead_Knee_Flexion_FC", "Lead_Knee_Flexion_MER_delta", "Lead_Knee_Flexion_MER",
  "Lead_Knee_Flexion_BR","Lead_Knee_Flexion_BR_delta", "Lead_Knee_Extension_Velo_Max", 
  "Lead_Knee_Extension_Velo_Max_to_BR_Timing", "Shoulder_Rotation_FC", 
  "Shoulder_Horz_Abduction_FC", "Elbow_Flexion_FC", 
  "Shoulder_Rotation_MER", "Shoulder_Horz_Abduction_MER", 
  "Max_Shoulder_Horz_Abduction_to_FC_Timing", "On_Plane_Percentage", 
  "Elbow_Flexion_Inside_90_FC_to_BR"
)

# Function to read PNG and return a grob
read_png_as_grob <- function(file) {
  img <- readPNG(file)
  rasterGrob(img, interpolate = TRUE)
}

# Get list of files from each folder
files_list <- lapply(folders, list.files, full.names = TRUE)

# Define the folder to save the combined plots
output_folder <- "C:/Users/benne/OneDrive/Documents/P3Work/p3_summer_2024/Bennett/Kina+Trackman+Assessment/BioMechGraphs/Combined_Pages2"

# Create output folder if it does not exist
if (!dir.exists(output_folder)) {
  dir.create(output_folder)
}

# Loop through the file names and create combined plots
for (file_name in file_names) {
  # Create a pattern for matching files with the current file name
  pattern <- paste0(file_name, "\\.png$")
  
  # Get the ith plot for the current file name from each folder
  plots <- lapply(folders, function(folder) {
    files <- list.files(folder, full.names = TRUE)
    matched_files <- grep(pattern, files, value = TRUE)
    if (length(matched_files) > 0) {
      read_png_as_grob(matched_files[1])
    } else {
      NULL
    }
  })
  
  # Remove NULL entries (folders that don't have the file)
  plots <- Filter(Negate(is.null), plots)
  
  # Check if we have enough plots to create a page
  if (length(plots) > 0) {
    # Combine the plots into a single image grid
    combined_plot <- do.call(grid.arrange, c(list(grobs = plots), list(nrow = 2, ncol = 4)))
    
    # Save the combined plot with the file name
    ggsave(filename = paste0(output_folder, "/combined_page_", file_name, ".png"), plot = combined_plot, width = 16, height = 12)
  }
}
