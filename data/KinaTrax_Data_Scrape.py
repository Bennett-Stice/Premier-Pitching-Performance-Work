# =============================================================================
# YOU HAVE TO RUN THIS CODE ON THE KINATRAX SERVER TO WORK CORRECTLY
# =============================================================================


import os
import pandas as pd

def read_line_6(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()
    
    if len(lines) >= 6:
        return lines[5].strip().split('\t')  # Assuming data is tab-separated
    else:
        return None

def process_files_in_directory(parent_directory):
    all_data = []
    
    for root, dirs, files in os.walk(parent_directory):
        if 'Pitching' in dirs:
            pitching_folder = os.path.join(root, 'Pitching')
            pitch_folders = os.listdir(pitching_folder)
            for pitch_folder in pitch_folders:
                pitch_folder_path = os.path.join(pitching_folder, pitch_folder)
                report_files = [f for f in os.listdir(pitch_folder_path) if f.endswith('.report.txt')]
                for report_file in report_files:
                    file_path = os.path.join(pitch_folder_path, report_file)
                    data_line_6 = read_line_6(file_path)
                    if data_line_6:
                        # Extract date and pitcher name from the folder and file names
                        pitch_date_time = pitch_folder[:19]  # Extract '2024_06_28_15_17_40'
                        pitcher_name = pitch_folder[20:]  # Extract 'Wil_Libbert'
                        
                        #print(pitcher_name)
                        
                        # Append date, time, pitcher name, and data to all_data
                        all_data.append([pitch_date_time, pitcher_name] + data_line_6)
    
    return all_data


# Example usage
parent_directory_2023 = r"E:\KinaTrax Dropbox\Premier Pitching Performance\Data\PPP\2023"

# Process all .report.txt files
data2023 = process_files_in_directory(parent_directory_2023)

# Example usage
parent_directory_2024 = r"E:\KinaTrax Dropbox\Premier Pitching Performance\Data\PPP\2024"

# Process all .report.txt files
data2024 = process_files_in_directory(parent_directory_2024)


# Create a dataframe
columns2024 = ["Pitch_Date_Time", "Pitcher_Name",
    "number", "Arm_Slot_Updated", "Lead_Knee_Ang_Vel_Max", "Lead_Knee_Ang_Vel_Max_PreBR",
    "Stride_Length", "Stride_Length_Percent", "01_START", "02_START_DATA", "03_MAX_KNEE_LIFT",
    "04_START_NORM", "05_RELEASE_MINUS_50", "06_FOOTSTRIKE", "07_MAX_EXTERNAL_SHOULDER_ROTATION",
    "08_RELEASE", "09_MAX_INTERNAL_SHOULDER_ROTATION", "10_RELEASE_PLUS_30", "11_END_NORM",
    "12_END_DATA", "13_END", "Knee_Height_In", "Knee_Height_PERCENT", "Step_Width_FtStrike_IN",
    "Stride_Length_Active_FtStrike", "Stride_Length_Active_Release", "Hand_Tunnel_MedialLateral_IN",
    "Hand_Tunnel_Forward_IN", "Hand_Tunnel_Vertical_IN", "HEIGHT", "MASS", "Shoulder_Rotation_Time",
    "Pelvis_Peak_Time", "Trunk_Peak_Time", "Pitching_UpperArm_KinematicSequence_Max",
    "Pitching_Shoulder_Rotation", "Pitching_Shoulder_AngVel_Rotation", "Pitching_Shoulder_Abduction",
    "Pitching_Shoulder_HorizontalAbduction", "Pitching_Shoulder_AngVel_HorizontalAbduction",
    "Pitching_Elbow_FlexionExtension", "Pitching_Elbow_AngVel_FlexionExtension",
    "Pitching_Elbow_Torque_VarusValgus", "Pitching_Elbow_PronationSupination", "Glove_Shoulder_Rotation",
    "Glove_Shoulder_Abduction", "Glove_Shoulder_HorizontalAbduction", "Glove_Elbow_FlexionExtension",
    "Trunk_WRT_Ground_Angle_ZYX_Lean", "Trunk_WRT_Ground_Angle_ZYX_ForwardTilt",
    "Trunk_WRT_Ground_Angle_ZYX_Rotation", "Hip_Shoulder_RotationalSeperation", "Pelvis_KinematicSequence",
    "Trunk_KinematicSequence", "Pitching_UpperArm_KinematicSequence", "Pitching_Hand_KinematicSequence",
    "Center_Mass_MedialLateral", "Center_Mass_Forward", "Center_Mass_Vertical",
    "Center_Mass_MedialLateral_Velocity", "Center_Mass_Forward_Velocity", "Center_Mass_Vertical_Velocity",
    "Trunk_WRT_Pelvis_Angle_ForwardTilt", "Trunk_WRT_Pelvis_Angle_Lean", "Trunk_WRT_Pelvis_Angle_Rotation",
    "Trunk_Rot_Acc", "Lead_Hip_Angle_FlexionExtension", "Lead_Hip_Angle_AbductionAdduction",
    "Lead_Hip_Angle_Rotation", "Lead_Knee_Angle_FlexionExtension", "Lead_Ankle_Angle_FlexionExtension",
    "Lead_Ankle_Angle_Rotation", "Lead_Foot_Orientation", "Trail_Hip_Angle_FlexionExtension",
    "Trail_Hip_Angle_AbductionAdduction", "Trail_Hip_Angle_Rotation", "Trail_Knee_Angle_FlexionExtension",
    "Trail_Ankle_Angle_FlexionExtension", "Trail_Ankle_Angle_Rotation", "Trail_Foot_Orientation",
    "Posterior_Foot_Angle", "Posterior_Forearm_Angle", "Pitching_Shoulder_Force", "Pitching_Shoulder_Torque",
    "Center_Mass_MedialLateral_Z", "Center_Mass_Forward_Z", "Center_Mass_Vertical_Z", "Head_CG_MedialLateral",
    "Head_CG_Forward", "Head_CG_Vertical", "Head_CG_MedialLateral_Z", "Head_CG_Forward_Z", "Head_CG_Vertical_Z",
    "Lead_Knee_FlexionExtension_Vel", "Trail_Knee_FlexionExtension_Vel", "Pelvis_WRT_Ground_Angle_ZYX_ForwardTilt",
    "Pelvis_WRT_Ground_Angle_ZYX_Lean", "Pelvis_WRT_Ground_Angle_ZYX_Rotation", "Lead_Hip_Ang_Vel_FlexionExtension",
    "Lead_Hip_Ang_Vel_Global_Rotation", "Trail_Hip_Ang_Vel_FlexionExtension", "Trail_Hip_Ang_Vel_Global_Rotation",
    "COM_AP_BR", "COM_AP_FC", "COM_AP_MER", "COM_ML_BR", "COM_ML_FC", "COM_ML_MER", "COM_VERT_BR", "COM_VERT_FC",
    "COM_VERT_MER", "Elb_Flex_BR", "Elb_Flex_FC", "Elb_Flex_MER", "Glove_Elb_Flex_BR", "Glove_Elb_Flex_FC",
    "Glove_Elb_Flex_MER", "Elb_ProSup_BR", "Elb_ProSup_FC", "Elb_ProSup_MER", "Elb_Var_Torque_MER",
    "ELBOW_BR_TIMING", "ELBOW_SHOULDER_TIMING", "FC_PELVIS_TIMING", "HAND_BR_TIMING", "Hip_Sho_Sep_FC",
    "Lead_Ankle_EvInv_BR", "Lead_Ankle_EvInv_FC", "Lead_Ankle_EvInv_MER", "Lead_Ankle_Flex_BR", "Lead_Ankle_Flex_FC",
    "Lead_Ankle_Flex_MER", "Lead_Foot_Orientation_FC", "Lead_Hip_AbAd_BR", "Lead_Hip_AbAd_FC", "Lead_Hip_AbAd_MER",
    "Lead_Hip_Flex_BR", "Lead_Hip_Flex_FC", "Lead_Hip_Flex_MER", "Lead_Hip_Flex_Vel_BR", "Lead_Hip_Rot_BR",
    "Lead_Hip_Rot_FC", "Lead_Hip_Rot_MER", "Lead_Knee_Flex_BR", "Lead_Knee_Flex_FC", "Lead_Knee_Flex_MER",
    "Lead_Knee_Flex_Vel_BR", "Lead_Knee_Flex_Vel_FC", "Lead_Knee_Flex_Vel_MER", "Max_COM_AP_Vel", "Max_Elb_Var_Torque",
    "Max_Hip_Sho_Sep", "Max_Lead_Hip_Flexion_Vel", "Max_Lead_Hip_Rotation_Vel", "Max_Resultant_Sho_Force",
    "Max_Sho_Horz_AbAd", "Max_Sho_Rot_Torque", "Max_Trail_Hip_Extension_Vel", "Max_Trail_Hip_Rotation_Vel",
    "Max_Trunk_Flexion", "Max_Trunk_Lean", "Max_Trunk_Pelvis_Flexion", "Max_Trunk_Pelvis_Lean", "MEEV", "MHV", "MPRV",
    "MSRV", "MTRV", "Normalized_Elb_Var_Torque_MER", "Normalized_Max_Elb_Var_Torque", "Normalized_Max_Resultant_Sho_Force",
    "Normalized_Max_Sho_Rot_Torque", "Normalized_Resultant_Sho_Force_MER", "Normalized_Sho_Rot_Torque_MER", "PELVIS_TRUNK_TIMING",
    "Resultant_Sho_Force_MER", "Sho_AbAd_BR", "Sho_AbAd_FC", "Sho_AbAd_MER", "Sho_Horz_AbAd_BR", "Sho_Horz_AbAd_FC",
    "Sho_Horz_AbAd_MER", "Sho_Rot_BR", "Sho_Rot_FC", "Sho_Rot_MER", "Glove_Sho_AbAd_BR", "Glove_Sho_AbAd_FC", "Glove_Sho_AbAd_MER",
    "Glove_Sho_Horz_AbAd_BR", "Glove_Sho_Horz_AbAd_FC", "Glove_Sho_Horz_AbAd_MER", "Glove_Sho_Rot_BR", "Glove_Sho_Rot_FC",
    "Glove_Sho_Rot_MER", "Sho_Rot_Torque_MER", "Sho_Rot_Vel_BR", "SHOULDER_BR_TIMING", "SHOULDER_HAND_TIMING", "Trail_Ankle_EvInv_BR",
    "Trail_Ankle_EvInv_FC", "Trail_Ankle_EvInv_MER", "Trail_Ankle_Flex_BR", "Trail_Ankle_Flex_FC", "Trail_Ankle_Flex_MER",
    "Trail_Foot_Orientation_FC", "Trail_Hip_AbAd_BR", "Trail_Hip_AbAd_FC", "Trail_Hip_AbAd_MER", "TRAIL_HIP_EXT_FC_TIMING",
    "Trail_Hip_Ext_Vel_FC", "Trail_Hip_Flex_BR", "Trail_Hip_Flex_FC", "Trail_Hip_Flex_MER", "Trail_Hip_Rot_BR", "Trail_Hip_Rot_FC",
    "TRAIL_HIP_ROT_FC_TIMING", "Trail_Hip_Rot_MER", "Trail_Knee_Flex_FC", "TRUNK_ELBOW_TIMING", "Trunk_Flexion_BR", "Trunk_Flexion_FC",
    "Trunk_Flexion_MER", "Trunk_Lean_BR", "Trunk_Lean_FC", "Trunk_Lean_MER", "Trunk_Pelvis_Flexion_BR", "Trunk_Pelvis_Flexion_FC",
    "Trunk_Pelvis_Flexion_MER", "Trunk_Pelvis_Lean_BR", "Trunk_Pelvis_Lean_FC", "Trunk_Pelvis_Lean_MER", "Trunk_Pelvis_Rotation_BR",
    "Trunk_Pelvis_Rotation_FC", "Trunk_Pelvis_Rotation_MER", "Trunk_Rotation_BR", "Trunk_Rotation_FC", "Trunk_Rotation_MER",
    "Pelvis_Flexion_BR", "Pelvis_Flexion_FC", "Pelvis_Flexion_MER", "Pelvis_Lean_BR", "Pelvis_Lean_FC", "Pelvis_Lean_MER",
    "Pelvis_Rotation_BR", "Pelvis_Rotation_FC", "Pelvis_Rotation_MER", "LEAD_HIP_ROT_FC_TIMING", "LEAD_HIP_FLEX_FC_TIMING",
    "COM_AP_Z_BR", "COM_AP_Z_FC", "COM_AP_Z_MER", "COM_ML_Z_BR", "COM_ML_Z_FC", "COM_ML_Z_MER", "COM_VERT_Z_BR", "COM_VERT_Z_FC",
    "COM_VERT_Z_MER", "HEAD_AP_BR", "HEAD_AP_FC", "HEAD_AP_MER", "HEAD_AP_Z_BR", "HEAD_AP_Z_FC", "HEAD_AP_Z_MER", "HEAD_ML_BR",
    "HEAD_ML_FC", "HEAD_ML_MER", "HEAD_ML_Z_BR", "HEAD_ML_Z_FC", "HEAD_ML_Z_MER", "HEAD_VERT_BR", "HEAD_VERT_FC", "HEAD_VERT_MER",
    "HEAD_VERT_Z_BR", "HEAD_VERT_Z_FC", "HEAD_VERT_Z_MER", "Head_WRT_Ground_Angle_ZYX_ForwardTilt", "Head_WRT_Ground_Angle_ZYX_Lean",
    "Head_WRT_Ground_Angle_ZYX_Rotation", "Head_Flexion_BR", "Head_Flexion_FC", "Head_Flexion_MER", "Head_Lean_BR", "Head_Lean_FC",
    "Head_Lean_MER", "Head_Rotation_BR", "Head_Rotation_FC", "Head_Rotation_MER", "COM_AP_VEL_BR", "COM_AP_VEL_FC", "COM_AP_VEL_MER",
    "COM_ML_VEL_BR", "COM_ML_VEL_FC", "COM_ML_VEL_MER", "COM_VERT_VEL_BR", "COM_VERT_VEL_FC", "COM_VERT_VEL_MER", "Elbow_Greater_90_BR",
    "Forearm_Alignment_Angle_FP", "Foot_Alignment_Angle_FP", "Foot_Arm_Angle_FP", "Grounded_Trunk_Rot_CR", "Grounded_Pelv_Rot_CR",
    "Max_Trunk_Acc", "Handedness", "KT_Data_Type", "FC_SCAP_RETR_TIMING", "HSS_FC_TIMING", "BR_MKEV_TIMING", "Shoulder_Plane_Percentage",
    "Upper_Arm_Slot", "Forearm_Slot", "Trail_Knee_Ang_Vel_Max", "Trail_GRF_MedialLateral_X_Predicted", "Trail_GRF_AnteriorPosterior_Y_Predicted",
    "Trail_GRF_Vertical_Z_Predicted", "TRAIL_GRF_MAG_Predicted", "Lead_GRF_MedialLateral_X_Predicted", "Lead_GRF_AnteriorPosterior_Y_Predicted",
    "Lead_GRF_Vertical_Z_Predicted", "LEAD_GRF_MAG_Predicted", "PEAK_BF_VERT_FORCE_Predicted", "NORMALIZED_PEAK_BF_VERT_FORCE_Predicted",
    "PEAK_BF_AP_FORCE_Predicted", "NORMALIZED_PEAK_BF_AP_FORCE_Predicted", "BF_AP_FORCE_FC_TIMING_Predicted", "PEAK_BF_ML_FORCE_Predicted",
    "NORMALIZED_PEAK_BF_ML_FORCE_Predicted", "BF_ML_FORCE_FC_TIMING_Predicted", "MAX_BF_ML_FORCE_Predicted", "NORMALIZED_MAX_BF_ML_FORCE_Predicted",
    "PEAK_BF_RESULTANT_FORCE_Predicted", "NORMALIZED_PEAK_BF_RESULTANT_FORCE_Predicted", "Max_Trail_GRF_FC_Timing_Predicted",
    "PEAK_FF_VERT_FORCE_Predicted", "NORMALIZED_PEAK_FF_VERT_FORCE_Predicted", "FF_VERT_RFD_Predicted", "NORMALIZED_FF_VERT_RFD_Predicted",
    "PEAK_FF_AP_FORCE_Predicted", "NORMALIZED_PEAK_FF_AP_FORCE_Predicted", "FF_AP_RFD_Predicted", "NORMALIZED_FF_AP_RFD_Predicted",
    "MIN_FF_ML_FORCE_Predicted", "NORMALIZED_MIN_FF_ML_FORCE_Predicted", "PEAK_FF_ML_FORCE_Predicted", "NORMALIZED_PEAK_FF_ML_FORCE_Predicted",
    "PEAK_FF_RESULTANT_FORCE_Predicted", "NORMALIZED_PEAK_FF_RESULTANT_FORCE_Predicted", "FF_RESULTANT_RFD_Predicted",
    "NORMALIZED_FF_RESULTANT_RFD_Predicted", "Lead_GRF_ML_Angle_FtStrike_Predicted", "Lead_GRF_AP_Angle_FtStrike_Predicted",
    "Lead_GRF_Vert_Angle_FtStrike_Predicted"]

columns2023 = ["Pitch_Date_Time", "Pitcher_Name","number",
               "Arm_Slot_Updated", "Lead_Knee_Ang_Vel_Max", "Lead_Knee_Ang_Vel_Max_PreBR",
               "Stride_Length", "Stride_Length_Percent", "01_START", "02_START_DATA", 
               "03_MAX_KNEE_LIFT", "04_START_NORM", "05_RELEASE_MINUS_50", "06_FOOTSTRIKE", 
               "07_MAX_EXTERNAL_SHOULDER_ROTATION", "08_RELEASE", "09_MAX_INTERNAL_SHOULDER_ROTATION", 
               "10_RELEASE_PLUS_30", "11_END_NORM", "12_END_DATA", "13_END", "Knee_Height_In", 
               "Knee_Height_PERCENT", "Step_Width_FtStrike_IN", "Stride_Length_Active_FtStrike", 
               "Stride_Length_Active_Release", "Hand_Tunnel_MedialLateral_IN", "Hand_Tunnel_Forward_IN", 
               "Hand_Tunnel_Vertical_IN", "HEIGHT", "MASS", "Shoulder_Rotation_Time", "Pelvis_Peak_Time", 
               "Trunk_Peak_Time", "Pitching_UpperArm_KinematicSequence_Max", "Pitching_Shoulder_Rotation", 
               "Pitching_Shoulder_AngVel_Rotation", "Pitching_Shoulder_Abduction", 
               "Pitching_Shoulder_HorizontalAbduction", "Pitching_Shoulder_AngVel_HorizontalAbduction", 
               "Pitching_Elbow_FlexionExtension", "Pitching_Elbow_AngVel_FlexionExtension", 
               "Pitching_Elbow_Torque_VarusValgus", "Pitching_Elbow_PronationSupination", "Glove_Shoulder_Rotation", 
               "Glove_Shoulder_Abduction", "Glove_Shoulder_HorizontalAbduction", "Glove_Elbow_FlexionExtension", 
               "Trunk_WRT_Ground_Angle_ZYX_Lean", "Trunk_WRT_Ground_Angle_ZYX_ForwardTilt", 
               "Trunk_WRT_Ground_Angle_ZYX_Rotation", "Hip_Shoulder_RotationalSeperation", "Pelvis_KinematicSequence", 
               "Trunk_KinematicSequence", "Pitching_UpperArm_KinematicSequence", "Pitching_Hand_KinematicSequence", 
               "Center_Mass_MedialLateral", "Center_Mass_Forward", "Center_Mass_Vertical", 
               "Center_Mass_MedialLateral_Velocity", "Center_Mass_Forward_Velocity", "Center_Mass_Vertical_Velocity", 
               "Trunk_WRT_Pelvis_Angle_ForwardTilt", "Trunk_WRT_Pelvis_Angle_Lean", "Trunk_WRT_Pelvis_Angle_Rotation", 
               "Trunk_Rot_Acc", "Lead_Hip_Angle_FlexionExtension", "Lead_Hip_Angle_AbductionAdduction", 
               "Lead_Hip_Angle_Rotation", "Lead_Knee_Angle_FlexionExtension", "Lead_Ankle_Angle_FlexionExtension", 
               "Lead_Ankle_Angle_Rotation", "Lead_Foot_Orientation", "Trail_Hip_Angle_FlexionExtension", 
               "Trail_Hip_Angle_AbductionAdduction", "Trail_Hip_Angle_Rotation", "Trail_Knee_Angle_FlexionExtension", 
               "Trail_Ankle_Angle_FlexionExtension", "Trail_Ankle_Angle_Rotation", "Trail_Foot_Orientation", 
               "Posterior_Foot_Angle", "Posterior_Forearm_Angle", "Pitching_Shoulder_Force", "Pitching_Shoulder_Torque",
               "Center_Mass_MedialLateral_Z", "Center_Mass_Forward_Z", "Center_Mass_Vertical_Z", 
               "Head_CG_MedialLateral", "Head_CG_Forward", "Head_CG_Vertical", "Head_CG_MedialLateral_Z", 
               "Head_CG_Forward_Z", "Head_CG_Vertical_Z", "Lead_Knee_FlexionExtension_Vel", 
               "Trail_Knee_FlexionExtension_Vel", "Pelvis_WRT_Ground_Angle_ZYX_ForwardTilt", 
               "Pelvis_WRT_Ground_Angle_ZYX_Lean", "Pelvis_WRT_Ground_Angle_ZYX_Rotation", 
               "Lead_Hip_Ang_Vel_FlexionExtension", "Lead_Hip_Ang_Vel_Global_Rotation", 
               "Trail_Hip_Ang_Vel_FlexionExtension", "Trail_Hip_Ang_Vel_Global_Rotation", "COM_AP_BR", "COM_AP_FC", 
               "COM_AP_MER", "COM_ML_BR", "COM_ML_FC", "COM_ML_MER", "COM_VERT_BR", "COM_VERT_FC", "COM_VERT_MER", 
               "Elb_Flex_BR", "Elb_Flex_FC", "Elb_Flex_MER", "Glove_Elb_Flex_BR", "Glove_Elb_Flex_FC", 
               "Glove_Elb_Flex_MER", "Elb_ProSup_BR", "Elb_ProSup_FC", "Elb_ProSup_MER", "Elb_Var_Torque_MER", 
               "ELBOW_BR_TIMING", "ELBOW_SHOULDER_TIMING", "FC_PELVIS_TIMING", "HAND_BR_TIMING", "Hip_Sho_Sep_FC", 
               "Lead_Ankle_EvInv_BR", "Lead_Ankle_EvInv_FC", "Lead_Ankle_EvInv_MER", "Lead_Ankle_Flex_BR", 
               "Lead_Ankle_Flex_FC", "Lead_Ankle_Flex_MER", "Lead_Foot_Orientation_FC", "Lead_Hip_AbAd_BR", 
               "Lead_Hip_AbAd_FC", "Lead_Hip_AbAd_MER", "Lead_Hip_Flex_BR", "Lead_Hip_Flex_FC", "Lead_Hip_Flex_MER", 
               "Lead_Hip_Flex_Vel_BR", "Lead_Hip_Rot_BR", "Lead_Hip_Rot_FC", "Lead_Hip_Rot_MER", "Lead_Knee_Flex_BR",
               "Lead_Knee_Flex_FC", "Lead_Knee_Flex_MER", "Lead_Knee_Flex_Vel_BR", "Lead_Knee_Flex_Vel_FC", 
               "Lead_Knee_Flex_Vel_MER", "Max_COM_AP_Vel", "Max_Elb_Var_Torque", "Max_Hip_Sho_Sep", 
               "Max_Lead_Hip_Flexion_Vel", "Max_Lead_Hip_Rotation_Vel", "Max_Resultant_Sho_Force", "Max_Sho_Horz_AbAd",
               "Max_Sho_Rot_Torque", "Max_Trail_Hip_Extension_Vel", "Max_Trail_Hip_Rotation_Vel", "Max_Trunk_Flexion", 
               "Max_Trunk_Lean", "Max_Trunk_Pelvis_Flexion", "Max_Trunk_Pelvis_Lean", "MEEV", "MHV", "MPRV", "MSRV", 
               "MTRV", "Normalized_Elb_Var_Torque_MER", "Normalized_Max_Elb_Var_Torque", 
               "Normalized_Max_Resultant_Sho_Force", "Normalized_Max_Sho_Rot_Torque", 
               "Normalized_Resultant_Sho_Force_MER", "Normalized_Sho_Rot_Torque_MER", "PELVIS_TRUNK_TIMING", 
               "Resultant_Sho_Force_MER", "Sho_AbAd_BR", "Sho_AbAd_FC", "Sho_AbAd_MER", "Sho_Horz_AbAd_BR", 
               "Sho_Horz_AbAd_FC", "Sho_Horz_AbAd_MER", "Sho_Rot_BR", "Sho_Rot_FC", "Sho_Rot_MER", "Glove_Sho_AbAd_BR", 
               "Glove_Sho_AbAd_FC", "Glove_Sho_AbAd_MER", "Glove_Sho_Horz_AbAd_BR", "Glove_Sho_Horz_AbAd_FC", 
               "Glove_Sho_Horz_AbAd_MER", "Glove_Sho_Rot_BR", "Glove_Sho_Rot_FC", "Glove_Sho_Rot_MER", 
               "Sho_Rot_Torque_MER", "Sho_Rot_Vel_BR", "SHOULDER_BR_TIMING", "SHOULDER_HAND_TIMING", 
               "Trail_Ankle_EvInv_BR", "Trail_Ankle_EvInv_FC", "Trail_Ankle_EvInv_MER", "Trail_Ankle_Flex_BR", 
               "Trail_Ankle_Flex_FC", "Trail_Ankle_Flex_MER", "Trail_Foot_Orientation_FC", "Trail_Hip_AbAd_BR", 
               "Trail_Hip_AbAd_FC", "Trail_Hip_AbAd_MER", "TRAIL_HIP_EXT_FC_TIMING", "Trail_Hip_Ext_Vel_FC", 
               "Trail_Hip_Flex_BR", "Trail_Hip_Flex_FC", "Trail_Hip_Flex_MER", "Trail_Hip_Rot_BR", "Trail_Hip_Rot_FC", 
               "TRAIL_HIP_ROT_FC_TIMING", "Trail_Hip_Rot_MER", "Trail_Knee_Flex_FC", "TRUNK_ELBOW_TIMING", 
               "Trunk_Flexion_BR", "Trunk_Flexion_FC", "Trunk_Flexion_MER", "Trunk_Lean_BR", "Trunk_Lean_FC", 
               "Trunk_Lean_MER", "Trunk_Pelvis_Flexion_BR", "Trunk_Pelvis_Flexion_FC", "Trunk_Pelvis_Flexion_MER", 
               "Trunk_Pelvis_Lean_BR", "Trunk_Pelvis_Lean_FC", "Trunk_Pelvis_Lean_MER", "Trunk_Pelvis_Rotation_BR", 
               "Trunk_Pelvis_Rotation_FC", "Trunk_Pelvis_Rotation_MER", "Trunk_Rotation_BR", "Trunk_Rotation_FC", 
               "Trunk_Rotation_MER", "Pelvis_Flexion_BR", "Pelvis_Flexion_FC", "Pelvis_Flexion_MER", "Pelvis_Lean_BR", 
               "Pelvis_Lean_FC", "Pelvis_Lean_MER", "Pelvis_Rotation_BR", "Pelvis_Rotation_FC", "Pelvis_Rotation_MER", 
               "LEAD_HIP_ROT_FC_TIMING", "LEAD_HIP_FLEX_FC_TIMING", "COM_AP_Z_BR", "COM_AP_Z_FC", "COM_AP_Z_MER", 
               "COM_ML_Z_BR", "COM_ML_Z_FC", "COM_ML_Z_MER", "COM_VERT_Z_BR", "COM_VERT_Z_FC", "COM_VERT_Z_MER", 
               "HEAD_AP_BR", "HEAD_AP_FC", "HEAD_AP_MER", "HEAD_AP_Z_BR", "HEAD_AP_Z_FC", "HEAD_AP_Z_MER", "HEAD_ML_BR",
               "HEAD_ML_FC", "HEAD_ML_MER", "HEAD_ML_Z_BR", "HEAD_ML_Z_FC", "HEAD_ML_Z_MER", "HEAD_VERT_BR", 
               "HEAD_VERT_FC", "HEAD_VERT_MER", "HEAD_VERT_Z_BR", "HEAD_VERT_Z_FC", "HEAD_VERT_Z_MER", 
               "Head_WRT_Ground_Angle_ZYX_ForwardTilt", "Head_WRT_Ground_Angle_ZYX_Lean", 
               "Head_WRT_Ground_Angle_ZYX_Rotation", "Head_Flexion_BR", "Head_Flexion_FC", "Head_Flexion_MER", 
               "Head_Lean_BR", "Head_Lean_FC", "Head_Lean_MER", "Head_Rotation_BR", "Head_Rotation_FC", 
               "Head_Rotation_MER", "COM_AP_VEL_BR", "COM_AP_VEL_FC", "COM_AP_VEL_MER", "COM_ML_VEL_BR", 
               "COM_ML_VEL_FC", "COM_ML_VEL_MER", "COM_VERT_VEL_BR", "COM_VERT_VEL_FC", "COM_VERT_VEL_MER", 
               "Elbow_Greater_90_BR", "Forearm_Alignment_Angle_FP", "Foot_Alignment_Angle_FP", "Foot_Arm_Angle_FP", 
               "Grounded_Trunk_Rot_CR", "Grounded_Pelv_Rot_CR", "Max_Trunk_Acc", "Handedness", "KT_Data_Type", 
               "FC_SCAP_RETR_TIMING", "HSS_FC_TIMING", "BR_MKEV_TIMING", "Shoulder_Plane_Percentage", "Upper_Arm_Slot",
               "Forearm_Slot", "Trail_Knee_Ang_Vel_Max", "Trail_GRF_MedialLateral_X_Predicted", 
               "Trail_GRF_AnteriorPosterior_Y_Predicted", "Trail_GRF_Vertical_Z_Predicted", "TRAIL_GRF_MAG_Predicted", 
               "Lead_GRF_MedialLateral_X_Predicted", "Lead_GRF_AnteriorPosterior_Y_Predicted", 
               "Lead_GRF_Vertical_Z_Predicted", "LEAD_GRF_MAG_Predicted", "PEAK_BF_VERT_FORCE_Predicted", 
               "NORMALIZED_PEAK_BF_VERT_FORCE_Predicted", "PEAK_BF_AP_FORCE_Predicted", 
               "NORMALIZED_PEAK_BF_AP_FORCE_Predicted", "BF_AP_FORCE_FC_TIMING_Predicted", 
               "PEAK_BF_ML_FORCE_Predicted", "NORMALIZED_PEAK_BF_ML_FORCE_Predicted", 
               "BF_ML_FORCE_FC_TIMING_Predicted", "PEAK_BF_RESULTANT_FORCE_Predicted", 
               "NORMALIZED_PEAK_BF_RESULTANT_FORCE_Predicted", "PEAK_FF_VERT_FORCE_Predicted", 
               "NORMALIZED_PEAK_FF_VERT_FORCE_Predicted", "FF_VERT_RFD_Predicted", "NORMALIZED_FF_VERT_RFD_Predicted", 
               "PEAK_FF_AP_FORCE_Predicted", "NORMALIZED_PEAK_FF_AP_FORCE_Predicted", "FF_AP_RFD_Predicted", 
               "NORMALIZED_FF_AP_RFD_Predicted", "MIN_FF_ML_FORCE_Predicted", "NORMALIZED_MIN_FF_ML_FORCE_Predicted", 
               "PEAK_FF_ML_FORCE_Predicted", "NORMALIZED_PEAK_FF_ML_FORCE_Predicted", 
               "PEAK_FF_RESULTANT_FORCE_Predicted", "NORMALIZED_PEAK_FF_RESULTANT_FORCE_Predicted", 
               "FF_RESULTANT_RFD_Predicted", "NORMALIZED_FF_RESULTANT_RFD_Predicted"]

################################## Handle 2023 Data #########################
#Create DataFrame
df_2023 = pd.DataFrame(data2023, columns= columns2023)

# Convert Pitch_Date_Time to datetime format
df_2023['Pitch_Date_Time'] = pd.to_datetime(df_2023['Pitch_Date_Time'], format='%Y_%m_%d_%H_%M_%S')

# Create separate date and time columns
df_2023['Date'] = df_2023['Pitch_Date_Time'].dt.date
df_2023['Time'] = df_2023['Pitch_Date_Time'].dt.time

df_2023['Level']= df_2023['Pitcher_Name'].str.split('_').str[0]
# Extract Fname and Lname from Pitcher_Name
df_2023['Fname'] = df_2023['Pitcher_Name'].str.split('_').str[2]
df_2023['Lname'] = df_2023['Pitcher_Name'].str.split('_').str[3]


# Conditionally handle cases where Fname is in the fourth position and Lname is in the fifth position
for index, val in df_2023.iterrows():
    if val['Fname'].isdigit():
        df_2023.at[index, 'Fname'] = df_2023.at[index, 'Pitcher_Name'].split('_')[3]
        df_2023.at[index, 'Lname'] = df_2023.at[index, 'Pitcher_Name'].split('_')[4]

# Drop the original Pitcher_Name column
df_2023.drop(columns=['Pitcher_Name'], inplace=True)

new_order = ['Date', 'Time', 'Fname', 'Lname', 'Level'] + [col for col in df_2023.columns if col not in ['Date', 'Time', 'Fname', 'Lname', 'Level']]
df_2023 = df_2023[new_order]

# Export DataFrame to CSV
csv_file_path_2023 = r"E:\tempkinatraxcsvs\kinatraxvalues2023.csv"
df_2023.to_csv(csv_file_path_2023, index=False)

print(f"2023 CSV file saved to: {csv_file_path_2023}")

################################## Handle 2024 Data #########################

#Create DataFrame
df_2024 = pd.DataFrame(data2024, columns= columns2024)

# Convert Pitch_Date_Time to datetime format
df_2024['Pitch_Date_Time'] = pd.to_datetime(df_2024['Pitch_Date_Time'], format='%Y_%m_%d_%H_%M_%S')

# Create separate date and time columns
df_2024['Date'] = df_2024['Pitch_Date_Time'].dt.date
df_2024['Time'] = df_2024['Pitch_Date_Time'].dt.time

df_2024['Level']= df_2024['Pitcher_Name'].str.split('_').str[0]
# Extract Fname and Lname from Pitcher_Name
df_2024['Fname'] = df_2024['Pitcher_Name'].str.split('_').str[2]
df_2024['Lname'] = df_2024['Pitcher_Name'].str.split('_').str[3]


# Conditionally handle cases where Fname is in the fourth position and Lname is in the fifth position
for index, val in df_2024.iterrows():
    if val['Fname'].isdigit():
        df_2024.at[index, 'Fname'] = df_2024.at[index, 'Pitcher_Name'].split('_')[3]
        df_2024.at[index, 'Lname'] = df_2024.at[index, 'Pitcher_Name'].split('_')[4]

# Drop the original Pitcher_Name column
df_2024.drop(columns=['Pitcher_Name'], inplace=True)

new_order = ['Date', 'Time', 'Fname', 'Lname', 'Level'] + [col for col in df_2024.columns if col not in ['Date', 'Time', 'Fname', 'Lname', 'Level']]
df_2024 = df_2024[new_order]

# Export DataFrame to CSV
csv_file_path_2024 = r"E:\tempkinatraxcsvs\kinatraxvalues2024.csv"
df_2024.to_csv(csv_file_path_2024, index=False)

print(f"2024 CSV file saved to: {csv_file_path_2024}")

################################## Combine 2023 and 2024 Data #########################

# Concatenate the DataFrames for 2023 and 2024
combined_df = pd.concat([df_2023, df_2024], ignore_index=True)

# Export combined DataFrame to CSV
combined_csv_file_path = r"E:\tempkinatraxcsvs\kinatraxvalues_combined.csv"
combined_df.to_csv(combined_csv_file_path, index=False)

print(f"Combined CSV file saved to: {combined_csv_file_path}")