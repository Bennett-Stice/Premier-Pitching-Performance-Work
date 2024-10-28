library(dplyr)

inputFiles <- c("Kinatrax+Trackman_over80.csv", "Kinatrax+Trackman_over85.csv", "Kinatrax+Trackman_over90.csv", "Kinatrax+Trackman_over95.csv")
outputFiles <- c("Boost_BioMech_Metrics_And_Velos_greater_than_80.csv", "Boost_BioMech_Metrics_And_Velos_greater_than_85.csv", "Boost_BioMech_Metrics_And_Velos_greater_than_90.csv", "Boost_BioMech_Metrics_And_Velos_greater_than_95.csv")

for (i in 1:length(inputFiles)) {
  # Read the input CSV file
  KinaTrax_TrackMan_Data <- read.csv(inputFiles[i])
  
  # Select and rename the columns
  Boost_BioMech_Metrics <- KinaTrax_TrackMan_Data %>% 
    select(Fname, Lname, pitch_type, release_speed, plate_location_height, plate_location_side, induced_vertical_break, horizontal_break, vertical_approach_angle, horizontal_approach_angle,
           MPRV, FC_PELVIS_TIMING, MTRV, PELVIS_TRUNK_TIMING, MEEV, TRUNK_ELBOW_TIMING, MSRV, ELBOW_SHOULDER_TIMING, SHOULDER_BR_TIMING,
           Stride_Length_Percent, Step_Width_FtStrike_IN, Max_COM_AP_Vel,
           Trunk_Rotation_FC, Pelvis_Rotation_FC, Hip_Sho_Sep_FC, HSS_FC_TIMING, Trunk_Flexion_FC, Trunk_Lean_FC,
           Lead_Knee_Flex_FC, Lead_Knee_Flex_MER, Lead_Knee_Flex_BR, Lead_Knee_Ang_Vel_Max, BR_MKEV_TIMING,
           Sho_Rot_FC, Sho_Horz_AbAd_FC, Elb_Flex_FC, Sho_Rot_MER, Sho_Horz_AbAd_MER, FC_SCAP_RETR_TIMING, Shoulder_Plane_Percentage, Elbow_Greater_90_BR) %>%
    rename(
      firstname = Fname,
      lastname = Lname,
      Pitch_Type = pitch_type,
      Velocity = release_speed,
      Plate_Location_Height = plate_location_height,
      Plate_Location_Side = plate_location_side,
      Induced_Vertical_Break = induced_vertical_break,
      Horizontal_Break = horizontal_break,
      Vertical_Approach_Angle = vertical_approach_angle,
      Horizontal_Approach_Angle = horizontal_approach_angle,
      Max_Pelvis_Rotational_Velocity = MPRV,
      FC_to_Pelvis_Timing = FC_PELVIS_TIMING,
      Max_Trunk_Rotational_Velocity = MTRV,
      Pelvis_to_Trunk_Timing = PELVIS_TRUNK_TIMING,
      Max_Elbow_Extension_Velocity = MEEV,
      Trunk_to_Elbow_Timing = TRUNK_ELBOW_TIMING,
      Max_Shoulder_Rotational_Velocity = MSRV,
      Elbow_to_Shoulder_Timing = ELBOW_SHOULDER_TIMING,
      Shoulder_to_BR_Timing = SHOULDER_BR_TIMING,
      Stride_Length_Percent = Stride_Length_Percent,
      Stride_Width_IN = Step_Width_FtStrike_IN,
      Max_COG_Velo = Max_COM_AP_Vel,
      Trunk_Rotation = Trunk_Rotation_FC,
      Pelvis_Rotation = Pelvis_Rotation_FC,
      Hip_Shoulder_Separation = Hip_Sho_Sep_FC,
      HSS_to_FC_Timing = HSS_FC_TIMING,
      Forward_Trunk_Tilt = Trunk_Flexion_FC,
      Trunk_Lean = Trunk_Lean_FC,
      Lead_Knee_Flexion_FC = Lead_Knee_Flex_FC,
      Lead_Knee_Flexion_MER = Lead_Knee_Flex_MER,
      Lead_Knee_Flexion_BR = Lead_Knee_Flex_BR,
      Lead_Knee_Extension_Velo_Max = Lead_Knee_Ang_Vel_Max,
      Lead_Knee_Extension_Velo_Max_to_BR_Timing = BR_MKEV_TIMING,
      Shoulder_Rotation_FC = Sho_Rot_FC,
      Shoulder_Horz_Abduction_FC = Sho_Horz_AbAd_FC,
      Elbow_Flexion_FC = Elb_Flex_FC,
      Shoulder_Rotation_MER = Sho_Rot_MER,
      Shoulder_Horz_Abduction_MER = Sho_Horz_AbAd_MER,
      Max_Shoulder_Horz_Abduction_to_FC_Timing = FC_SCAP_RETR_TIMING,
      On_Plane_Percentage = Shoulder_Plane_Percentage,
      Elbow_Flexion_Inside_90_FC_to_BR = Elbow_Greater_90_BR
    )
  
  # Write the output CSV file
  write.csv(Boost_BioMech_Metrics, outputFiles[i], row.names = FALSE)
}
