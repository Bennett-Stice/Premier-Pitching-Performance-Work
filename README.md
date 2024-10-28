# Premier-Pitching-Performance-Work
Work I did for Premier Pitching Perfomance as summer intern 2024


1. Arm Slot Project
This was a project I did to try to find outliers in pitch movement based on what a hitter expects to see from a given armslot. To do so I took Kinatrax values like Trunk Lean and Shoulder Abduction and Ball Release to create an arm angle relative to the ground. Then I grouped the pitcher's into 5 buckets based on their arm slots and normalized their induced vertical movement and horizontal movement. Then I looked at pitches who had the highest absolute z-score in each respective bucket and found that they were more effective in our in-house collegiate league than exepect if you looked at the movement profile without the arm-slot context

2. Data
This was just the scripts I used to pull trackman, assessment, and kinatrax data and format it into a usable csv for other intern's to use.

3. Height Weight Analysis
This was a project where I looked at how our clients height and weight affected their fastball velocity. Part of the project I used machine learning to see as mass increased did the athlete need to hit the same benchmarks on trunk rotation, lead knee extension or center of gravity velocity to throw the same speed. The second part of the project was to create height and weight groupings of our athletes. Then inside each goruping I would look at the percentage of athletes whose average fastball was 80-85, 85-90, 90-95, 95-100. This allowed athelete to find what bodyweight they should be at for their specific height.

4. Kina+Trackman+Assessments
The purpose of this project was to validate or disprove the curant in-house "ideal ranges" for key biomechanics metrics that our coaches taught. To do this I create machine learning models that looked at a single metric and predicted the velocity. Then graphing this from the min to max of that metric we could see where the model expected the hardest throwers to be. Then we showed where our current ideal ranges were and where we needed to change them.

5. Velo Web Correlation
The purpose of this project was to find which of the KPIs we tracked were most correlated with fastball velocity. Instead of finding the correlations of these KPIs straight to velocity. I found it better to find the correlations to certain biomechanics metrics that we knew had linear relationships with fastball velocity. These were trunk and pelvis rotational velocity, cog velocity, max shoulder rotational velocity, etc. This way I created a web that showed which KPIs lead to better mechanics to lead to velocity gains. 