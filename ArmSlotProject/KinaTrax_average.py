import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

# File path to your CSV file
kinatrax_csv_path = r"C:\Users\benne\OneDrive\Documents\P3Work\p3_summer_2024\Bennett\KinaTrax_Data\KinaTraxVals.csv"
trackman_csv_path = r"C:\Users\benne\OneDrive\Documents\P3Work\p3_summer_2024\Bennett\KinaTrax_Data\trackman_pitch_data.csv"

# Columns to extract for KinaTrax data
kinatrax_columns_of_interest = ["Fname", "Lname", "Trunk_Lean_BR", "Arm_Slot_Updated", "Sho_AbAd_BR"]

# Read KinaTrax CSV file into a DataFrame
df_slot = pd.read_csv(kinatrax_csv_path)

# Create a new DataFrame df_slot for averaging
df_slot = df_slot[kinatrax_columns_of_interest]

# Group by Fname and Lname, calculate mean of Trunk_Lean_BR and Sho_AbAd_BR
df_slot_avg = df_slot.groupby(['Fname', 'Lname']).agg({
    'Trunk_Lean_BR': 'mean',
    'Arm_Slot_Updated': 'mean',
    'Sho_AbAd_BR': 'mean'
}).reset_index()

# Calculate Total Arm Angle and Arm Slot Bucket
df_slot_avg['Total Arm Angle'] = abs(df_slot_avg['Trunk_Lean_BR']) + 90 - df_slot_avg['Arm_Slot_Updated']
df_slot_avg['Arm_Slot_Bucket'] = pd.cut(
    df_slot_avg['Total Arm Angle'],
    bins=[-float('inf'),10, 20, 30, 45, 60, float('inf')],
    labels=['SUB', 'SIDE','LOW 3/4', '3/4', 'HIGH 3/4', 'OTT']
)

############# Trackman Data

# Columns to extract for Trackman data
trackman_columns_of_interest = ["firstname", "lastname", "pitch_type", "release_speed", "horizontal_break", "induced_vertical_break"]

# Read Trackman CSV file into a DataFrame
df_pitches = pd.read_csv(trackman_csv_path)

# Filter Trackman DataFrame to only include the columns of interest
df_pitches = df_pitches[trackman_columns_of_interest]

# Merge the two DataFrames on firstname = Fname and lastname = Lname
df_merged = pd.merge(
    df_pitches,
    df_slot_avg,
    left_on=['firstname', 'lastname'],
    right_on=['Fname', 'Lname'],
    how='left'
)

# Drop duplicate columns
df_merged.drop(columns=['Fname', 'Lname'], inplace=True)

# Remove rows with NaN values in the Arm_Slot_Bucket column
df_merged = df_merged.dropna()

df_merged['abs_horizontal_break'] = abs(df_merged['horizontal_break'])

df_merged.to_csv("movements_with_slots.csv", index=False)

# Group by Arm_Slot_Bucket and pitch_type and calculate the mean for horizontal_break and induced_vertical_break
df_avg_breaks = df_merged.groupby(['Arm_Slot_Bucket', 'pitch_type']).agg({
    'abs_horizontal_break': ['mean','std'],
    'induced_vertical_break': ['mean','std']
}).reset_index()

# Flatten the column names after aggregation
df_avg_breaks.columns = ['Arm_Slot_Bucket', 'pitch_type', 'avg_horizontal_break', 'std_horizontal_break', 'avg_induced_vertical_break', 'std_induced_vertical_break']
df_avg_breaks_sorted = df_avg_breaks.sort_values(by=['pitch_type', 'Arm_Slot_Bucket']).reset_index(drop=True)

excel_file_path = 'average_breaks_by_pitch_type.xlsx'

# Create a Pandas Excel writer using XlsxWriter as the engine
with pd.ExcelWriter(excel_file_path, engine='xlsxwriter') as writer:
    
    # Iterate over unique pitch types
    for pitch_type in df_avg_breaks_sorted['pitch_type'].unique():
        # Filter dataframe for the current pitch type
        df_pitch_type = df_avg_breaks_sorted[df_avg_breaks_sorted['pitch_type'] == pitch_type]
        
        # Write dataframe to Excel sheet
        sheet_name = f'Pitch_Type_{pitch_type}'
        df_pitch_type.to_excel(writer, sheet_name=sheet_name, index=False)

    # Save the Excel file
    #writer.save()
    
print("done")

'''
# Plotting scatter plots for each pitcher
for (fname, lname), group in df_merged.groupby(['firstname', 'lastname']):
    plt.figure(figsize=(10, 6))
    sns.scatterplot(data=group, x='horizontal_break', y='induced_vertical_break', hue='pitch_type', palette='viridis')
    
    # Calculate the slope of the line
    total_arm_angle_degrees = group['Total Arm Angle'].iloc[0]
    slope_degrees = total_arm_angle_degrees
    
    # Convert degrees to radians
    slope_radians = np.deg2rad(slope_degrees)
    
    # Calculate rise (vertical component) and run (horizontal component)
    rise = np.sin(slope_radians)
    run = np.cos(slope_radians)
    
    # Adjust slope if horizontal_break of fastball (FB) is negative
    if 'FB' in group['pitch_type'].values:
        fb_horizontal_break = group[group['pitch_type'] == 'FB']['horizontal_break'].iloc[0]
        if fb_horizontal_break < 0:
            rise = -rise  # Flip the sign of rise
    
    # Define the line starting from (0,0) with calculated slope
    x_vals = np.array(plt.gca().get_xlim())
    y_vals = rise / run * x_vals
    
    # Plot the line
    plt.plot(x_vals, y_vals, '--', color='red')
    
    plt.title(f'Scatter Plot for {fname} {lname}')
    plt.xlabel('Horizontal Break')
    plt.ylabel('Induced Vertical Break')
    plt.legend(title='Pitch Type')
    plt.grid(True)
    plt.xlim(-25,25)
    plt.ylim(-25,25)
    #plt.show()

'''






