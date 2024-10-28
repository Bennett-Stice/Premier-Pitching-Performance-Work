# Load necessary libraries
suppressMessages(library(dplyr))
suppressMessages(library(ggplot2))
suppressMessages(library(fs))

# Read and prepare the data
data <- read.csv("Kinatrax+Trackman_over80.csv") %>%
  mutate(
    Momentum = MASS * Max_COM_AP_Vel,
    MASS_lb = round(MASS * 2.20462, 2),  # Convert kg to lb and round to 100th
    HEIGHT_in = round(HEIGHT * 39.3701, 2)  # Convert meters to inches and round to 100th
  )

# Calculate percentiles
height_mass_data <- data %>%
  group_by(firstname, lastname) %>%
  summarize(
    avg_release_speed = mean(release_speed, na.rm = TRUE),
    MASS_lb = mean(MASS_lb, na.rm = TRUE),
    HEIGHT_in = mean(HEIGHT_in, na.rm = TRUE)
  )

mass_percentiles <- quantile(height_mass_data$MASS_lb, probs = c(0.25, 0.5, 0.75), na.rm = TRUE)
height_percentiles <- quantile(height_mass_data$HEIGHT_in, probs = c(0.25, 0.5, 0.75), na.rm = TRUE)

# Define the function to get box
getBox <- function(mass, height) {
  mass_quartiles <- quantile(height_mass_data$MASS_lb, probs = c(0.25, 0.50, 0.75), na.rm = TRUE)
  height_quartiles <- quantile(height_mass_data$HEIGHT_in, probs = c(0.25, 0.50, 0.75), na.rm = TRUE)
  
  if (mass > mass_quartiles[3]) {
    if (height < height_quartiles[1]) {
      return(1)
    } else if (height < height_quartiles[2]) {
      return(2)
    } else if (height < height_quartiles[3]) {
      return(3)
    } else {
      return(4)
    }
  } else if (mass > mass_quartiles[2]) {
    if (height < height_quartiles[1]) {
      return(5)
    } else if (height < height_quartiles[2]) {
      return(6)
    } else if (height < height_quartiles[3]) {
      return(7)
    } else {
      return(8)
    }
  } else if (mass > mass_quartiles[1]) {
    if (height < height_quartiles[1]) {
      return(9)
    } else if (height < height_quartiles[2]) {
      return(10)
    } else if (height < height_quartiles[3]) {
      return(11)
    } else {
      return(12)
    }
  } else {
    if (height < height_quartiles[1]) {
      return(13)
    } else if (height < height_quartiles[2]) {
      return(14)
    } else if (height < height_quartiles[3]) {
      return(15)
    } else {
      return(16)
    }
  }
}

# Apply the getBox function
height_mass_data$box <- mapply(getBox, height_mass_data$MASS_lb, height_mass_data$HEIGHT_in)

# Define the function to classify average release speed
classify_speed <- function(speed) {
  if (speed >= 80 && speed < 85) {
    return('80-85')
  } else if (speed >= 85 && speed < 90) {
    return('85-90')
  } else if (speed >= 90 && speed < 95) {
    return('90-95')
  } else if (speed >= 95) {
    return('>95')
  } else {
    return('other')
  }
}

# Create a new column for speed categories
height_mass_data$velo_bucket <- mapply(classify_speed, height_mass_data$avg_release_speed)

# Calculate counts and percentages for each box
box_category_counts <- height_mass_data %>%
  group_by(box, velo_bucket) %>%
  summarize(count = n()) %>%
  ungroup()

total_counts <- box_category_counts %>%
  group_by(box) %>%
  summarize(total = sum(count))

box_category_percentages <- box_category_counts %>%
  left_join(total_counts, by = "box") %>%
  mutate(percentage = (count / total) * 100)

# Define a color palette
color_palette <- c('80-85' = 'lightblue', '85-90' = 'lightgreen', '90-95' = 'lightcoral', '>95' = 'orange',
                   'other' = 'black')

# Create a folder to save the plots
output_folder <- "C:/Users/benne/OneDrive/Documents/P3Work/p3_summer_2024/Bennett/Height_Weight_Analysis/PieCharts"
dir_create(output_folder)

# Save individual pie charts for each box
for (b in unique(box_category_percentages$box)) {
  box_data <- box_category_percentages %>%
    filter(box == b)
  
  pie_chart <- ggplot(box_data, aes(x = "", y = percentage, fill = velo_bucket)) +
    geom_bar(width = 1, stat = "identity") +
    coord_polar(theta = "y") +
    geom_text(aes(label = paste0(round(percentage, 1), "%")),
              position = position_stack(vjust = 0.5), size = 10) +
    scale_fill_manual(values = color_palette) +
    theme_void() +
    theme(
      legend.position = "none"
    )
  
  print(pie_chart)
  
  ggsave(filename = file.path(output_folder, paste0("box_", b, ".png")), plot = pie_chart, width = 6, height = 6)
}

# Save individual pie charts for row summaries
for (row in 1:4) {
  row_data <- box_category_percentages %>%
    filter(box %in% ((row - 1) * 4 + 1):((row - 1) * 4 + 4)) %>%
    group_by(velo_bucket) %>%
    summarize(count = sum(count), .groups = 'drop') %>%
    mutate(percentage = (count / sum(count)) * 100)
  
  pie_chart <- ggplot(row_data, aes(x = "", y = percentage, fill = velo_bucket)) +
    geom_bar(width = 1, stat = "identity") +
    coord_polar(theta = "y") +
    geom_text(aes(label = paste0(round(percentage, 1), "%")),
              position = position_stack(vjust = 0.5), size = 10) +
    scale_fill_manual(values = color_palette) +
    theme_void() +
    theme(
      legend.position = "none"
    )
  
  print(pie_chart)
  
  ggsave(filename = file.path(output_folder, paste0("row_", row, "_summary.png")), plot = pie_chart, width = 6, height = 6)
}

# Save individual pie charts for column summaries
for (col in 1:4) {
  col_data <- box_category_percentages %>%
    filter(box %in% c(col, col + 4, col + 8, col + 12)) %>%
    group_by(velo_bucket) %>%
    summarize(count = sum(count), .groups = 'drop') %>%
    mutate(percentage = (count / sum(count)) * 100)
  
  pie_chart <- ggplot(col_data, aes(x = "", y = percentage, fill = velo_bucket)) +
    geom_bar(width = 1, stat = "identity") +
    coord_polar(theta = "y") +
    geom_text(aes(label = paste0(round(percentage, 1), "%")),
              position = position_stack(vjust = 0.5), size = 10) +
    scale_fill_manual(values = color_palette) +
    theme_void() +
    theme(
      legend.position = "none"
    )
  
  print(pie_chart)
  
  ggsave(filename = file.path(output_folder, paste0("col_", col, "_summary.png")), plot = pie_chart, width = 6, height = 6)
}

# Save overall pie chart
overall_data <- box_category_percentages %>%
  group_by(velo_bucket) %>%
  summarize(count = sum(count), .groups = 'drop') %>%
  mutate(percentage = (count / sum(count)) * 100)

overall_pie_chart <- ggplot(overall_data, aes(x = "", y = percentage, fill = velo_bucket)) +
  geom_bar(width = 1, stat = "identity") +
  coord_polar(theta = "y") +
  geom_text(aes(label = paste0(round(percentage, 1), "%")),
            position = position_stack(vjust = 0.5), size = 10) +
  scale_fill_manual(values = color_palette) +
  theme_void() +
  theme(
    legend.position = "none"
  )

print(overall_pie_chart)

ggsave(filename = file.path(output_folder, "overall_summary.png"), plot = overall_pie_chart, width = 6, height = 6)
