# -*- coding: utf-8 -*-
"""
Created on Wed Jul  3 14:49:53 2024

@author: Bennett Stice
"""

import pandas as pd


df = pd.read_csv("movements_with_slots.csv")


def Calculate_Horz_Z_Score(value, pitch, angle):
   
    if (pitch == 'FB'):
        if (angle == 'SUB'):
            return ((value-22.8)/2.3)
        elif (angle == 'SIDE'):
            return ((value-15.0)/4.6)
        elif (angle == 'LOW 3/4'):
            return ((value-14.1)/3.9)
        elif (angle == '3/4'):
            return ((value-12.5)/4.7)
        elif (angle == 'HIGH 3/4'):
            return ((value-13.4)/3.6)
        elif (angle == 'OTT'):
            return ((value-9.2)/3.7)
    
    elif (pitch == 'SI'):
        if (angle == 'SUB'):
            return ((value-20.5)/3.7)
        elif (angle == 'SIDE'):
            return ((value-21.3)/2.2)
        elif (angle == 'LOW 3/4'):
            return ((value-17.8)/2.9)
        elif (angle == '3/4'):
            return ((value-16.5)/3.2)
        elif (angle == 'HIGH 3/4'):
            return ((value-15.1)/3.2)
        elif (angle == 'OTT'):
            return ((value-12.2)/4.3)
        
    elif (pitch == 'CT'):
        if (angle == 'LOW 3/4'):
            return ((value-1.6)/0.7)
        elif (angle == '3/4'):
            return ((value-7)/5.3)
        elif (angle == 'HIGH 3/4'):
            return ((value-6.6)/3.5)
        elif (angle == 'OTT'):
            return ((value-8.8)/1.5)    
        
    elif (pitch == 'CB'):
        if (angle == 'SIDE'):
            return ((value-15.0)/7.1)
        elif (angle == 'LOW 3/4'):
            return ((value-17.8)/3.2)
        elif (angle == '3/4'):
            return ((value-14.2)/5.2)
        elif (angle == 'HIGH 3/4'):
            return ((value-16.1)/4.5)
        elif (angle == 'OTT'):
            return ((value-14.1)/3.5)
        
    elif (pitch == 'SL'):
        if (angle == 'SUB'):
            return ((value-13.2)/3.8)
        elif (angle == 'SIDE'):
            return ((value-13.5)/9.4)
        elif (angle == 'LOW 3/4'):
            return ((value-12.8)/5.3)
        elif (angle == '3/4'):
            return ((value-16.5)/6.0)
        elif (angle == 'HIGH 3/4'):
            return ((value-13.0)/5.1)
        elif (angle == 'OTT'):
            return ((value-11.2)/6.3)
        
    elif (pitch == 'CH'):
        if (angle == 'SUB'):
            return ((value-17.0)/3.6)
        elif (angle == 'SIDE'):
            return ((value-21.5)/2.0)
        elif (angle == 'LOW 3/4'):
            return ((value-17.1)/3.3)
        elif (angle == '3/4'):
            return ((value-16.6)/4.4)
        elif (angle == 'HIGH 3/4'):
            return ((value-16.8)/3.6)
        elif (angle == 'OTT'):
            return ((value-15.1)/3.8)
    else:
        return None
        
        
        
def Calculate_Vert_Z_Score(value, pitch, angle):
 
    if (pitch == 'FB'):
        if (angle == 'SUB'):
            return ((value-0.7)/2.4)
        elif (angle == 'SIDE'):
            return ((value-13.2)/4.3)
        elif (angle == 'LOW 3/4'):
            return ((value-14.0)/3.0)
        elif (angle == '3/4'):
            return ((value-16.2)/3.1)
        elif (angle == 'HIGH 3/4'):
            return ((value-16.5)/3.9)
        elif (angle == 'OTT'):
            return ((value-18.6)/3.9)
    
    elif (pitch == 'SI'):
        if (angle == 'SUB'):
            return ((value-0.2)/4.8)
        elif (angle == 'SIDE'):
            return ((value-3.4)/5.7)
        elif (angle == 'LOW 3/4'):
            return ((value-10.3)/3.7)
        elif (angle == '3/4'):
            return ((value-12.6)/3.7)
        elif (angle == 'HIGH 3/4'):
            return ((value-15.3)/4.0)
        elif (angle == 'OTT'):
            return ((value-19.0)/3.7)
        
    elif (pitch == 'CT'):
        if (angle == 'LOW 3/4'):
            return ((value-6.7)/4.7)
        elif (angle == '3/4'):
            return ((value-10.5)/6.5)
        elif (angle == 'HIGH 3/4'):
            return ((value-12.1)/4.6)
        elif (angle == 'OTT'):
            return ((value-10.5)/0.6)    
        
    elif (pitch == 'CB'):
        if (angle == 'SIDE'):
            return ((value+8.4)/4.7)
        elif (angle == 'LOW 3/4'):
            return ((value+1.8)/4.3)
        elif (angle == '3/4'):
            return ((value+8.0)/6.4)
        elif (angle == 'HIGH 3/4'):
            return ((value+9.2)/5.6)
        elif (angle == 'OTT'):
            return ((value+12.1)/4.9)
        
    elif (pitch == 'SL'):
        if (angle == 'SUB'):
            return ((value-9.6)/3.0)
        elif (angle == 'SIDE'):
            return ((value-0.1)/5.1)
        elif (angle == 'LOW 3/4'):
            return ((value-0.9)/4.2)
        elif (angle == '3/4'):
            return ((value-0.6)/5.6)
        elif (angle == 'HIGH 3/4'):
            return ((value+1.4)/6.5)
        elif (angle == 'OTT'):
            return ((value-1.3)/5.4)
        
    elif (pitch == 'CH'):
        if (angle == 'SUB'):
            return ((value+5.5)/4.2)
        elif (angle == 'SIDE'):
            return ((value-5.0)/3.5)
        elif (angle == 'LOW 3/4'):
            return ((value-5.2)/3.7)
        elif (angle == '3/4'):
            return ((value-7.6)/5.8)
        elif (angle == 'HIGH 3/4'):
            return ((value-8.7)/4.3)
        elif (angle == 'OTT'):
            return ((value-14.7)/4.3)
        
    else:
        return None
    
df['Horz_Z_Score'] = df.apply(lambda row: Calculate_Horz_Z_Score(row['abs_horizontal_break'], row['pitch_type'], row['Arm_Slot_Bucket']), axis=1)
df['Vert_Z_Score'] = df.apply(lambda row: Calculate_Vert_Z_Score(row['induced_vertical_break'], row['pitch_type'], row['Arm_Slot_Bucket']), axis=1)


df_Name_Separated = df.groupby(['firstname', 'lastname','pitch_type']).agg({
    'Horz_Z_Score': 'mean',
    'Vert_Z_Score': 'mean'
}).reset_index()





