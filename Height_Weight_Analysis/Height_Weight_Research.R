# Load necessary libraries
library(dplyr)
library(ggplot2)
library(ggpubr)  # For arranging multiple plots
library(gridExtra)
library(grid)

# Read and prepare the data
data <- read.csv("Kinatrax+Trackman_over80.csv") %>%
  mutate(
    Momentum = MASS * Max_COM_AP_Vel,
    MASS_lb = round(MASS * 2.20462, 2),  # Convert kg to lb and round to 100th
    HEIGHT_in = round(HEIGHT * 39.3701, 2)  # Convert meters to inches and round to 100th
  )

# Compute correlations
correlation <- cor(data$Momentum, data$release_speed, use = "complete.obs")
print(paste("Correlation between Momentum and release_speed:", correlation))

massCorrelation <- cor(data$MASS, data$release_speed, use = "complete.obs")
print(paste("Correlation between MASS and Velo:", massCorrelation))

COGVELOCorrelation <- cor(data$Max_COM_AP_Vel, data$release_speed, use = "complete.obs")
print(paste("Correlation between COG and Velo:", COGVELOCorrelation))

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

print(paste("25th, 50th, and 75th percentiles of MASS (lb):", mass_percentiles))
print(paste("25th, 50th, and 75th percentiles of HEIGHT (in):", height_percentiles))

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

# Plot pie charts with counts and percentages
pie_charts <- lapply(unique(box_category_percentages$box), function(b) {
  box_data <- box_category_percentages %>%
    filter(box == b)
  
  pie_chart <- ggplot(box_data, aes(x = "", y = percentage, fill = velo_bucket)) +
    geom_bar(width = 1, stat = "identity") +
    coord_polar(theta = "y") +
    geom_text(aes(label = paste0(round(percentage, 1), "% (", count, " rows)")),
              position = position_stack(vjust = 0.5), size = 3) +
    scale_fill_manual(values = color_palette) +
    labs(
      title = NULL,
      fill = "Velo Bucket"
    ) +
    theme_void() +
    theme(
      legend.position = "bottom"
    )
  
  return(pie_chart)
})

# Create the layout for the grid with labels and lines
grob_list <- lapply(pie_charts, ggplotGrob)

# Add labels for height and weight percentiles
height_labels <- data.frame(
  x = rep(1, 3),
  y = c(0.25, 0.5, 0.75),
  label = paste0("Weight\n", round(mass_percentiles, 2))
)

weight_labels <- data.frame(
  x = c(0.25, 0.5, 0.75),
  y = rep(1, 3),
  label = paste0("Height\n", round(height_percentiles, 2))
)

# Combine the pie charts into a single plot
combined_plot <- ggarrange(
  plotlist = pie_charts,
  ncol = 4,
  nrow = 4,
  common.legend = TRUE,
  legend = "none"
)

# Draw the plot with lines and labels
grid.newpage()
grid.draw(combined_plot)

# Add horizontal and vertical lines between plots
for (i in 1:3) {
  grid.lines(x = unit(c(0, 1), "npc"), y = unit(i / 4, "npc"), gp = gpar(col = "black"))
}
for (i in 1:3) {
  grid.lines(x = unit(i / 4, "npc"), y = unit(c(0, 1), "npc"), gp = gpar(col = "black"))
}

# Add height labels
for (i in 1:4) {
  grid.text(label = height_labels$label[i], x = 0.02, y = height_labels$y[i], gp = gpar(fontsize = 10))
}

# Add weight labels
for (i in 1:4) {
  grid.text(label = weight_labels$label[i], x = weight_labels$x[i], y = 0.02, gp = gpar(fontsize = 10))
}

