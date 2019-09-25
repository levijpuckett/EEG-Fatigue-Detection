# Fatigue Detection from EEG Data
Prize-winning team design project from ECE 399, Fall 2018.

Accurate detection of fatigue levels in astronauts is critical to ensure safe space travel. This project outlines the design of a software-based system which determines a user’s fatigue level from electroencephalography (EEG) data in real time. The algorithm uses support vector machines (SVM) with a linear kernel to classify a short sample of EEG data as either "fatigued" or "rested." The SVM is trained on a feature vector of 40 selected features. MATLAB prototypes show greater than 90% classification accuracy using raw 4-channel EEG data.

## Feature Extraction
Raw 4-channel EEG data is fed into the classification system. This data is segmented into short epochs (less than 1 minute each) and the single-sided power spectral density is extracted. Four principal EEG bands are recognized in the literature: delta (0.4-4 Hz), theta (4-8 Hz), alpha (8-13 Hz), and beta (13-20 Hz). Two features from each band are extracted from each of the four channels. Two power ratios from each band are included in the feature vector, yielding 40 total features from each EEG epoch.

### Features
Two features from each band are extracted from each channel: the dominant frequency (DF) and the average power of the dominant peak (APDP). After the power spectral density of the raw EEG data has been extracted from an epoch, each band is analyzed for its DF and APDP. The DF is the frequency with the greatest power over its full-width at half-maximum (FWHM) band. The APDP is the average power of the DF over the FWHM band. The figure below illustrates the concept of dominant frequencies and FWHM bands.

![Alt text](DFAPDP.png?raw=true "DF and APDP Visualized.")

### Power Ratios


Fatigue Detection From EEG Data: Prize-winning team design project, Fall 2018
• Designed and prototyped an system which determines a user’s fatigue level from
electroencephalography data
• Worked as a team, developed individual action items and collaborated in meetings
• Prototyped in MATLAB, peak of 92% accuracy
• Extensive research, prototyping, and analysis
• Project won second place in third-year design project competition
