# Fatigue Detection from EEG Data
Prize-winning team design project from ECE 399, Fall 2018.

Accurate detection of fatigue levels in astronauts is critical to ensure safe space travel. This project outlines the design of a software-based system which determines a user’s fatigue level from electroencephalography (EEG) data in real time. The algorithm uses support vector machines (SVM) with a linear kernel to classify a short sample of EEG data as either "fatigued" or "rested." The SVM is trained on a feature vector of 40 selected features. MATLAB prototypes show over 90% classification accuracy using raw 4-channel EEG data.

## Feature Extraction
Raw 4-channel EEG data is fed into the classification system. This data is segmented into short epochs (less than 1 minute each) and the single-sided power spectral density is extracted. Four principal EEG bands are recognized in the literature: delta (0.4-4 Hz), theta (4-8 Hz), alpha (8-13 Hz), and beta (13-20 Hz). Two features from each band are extracted from each of the four channels. Two power ratios from each band are included in the feature vector, yielding 40 total features from each EEG epoch.

### Features
Two features from each band are extracted from each channel: the dominant frequency (DF) and the average power of the dominant peak (APDP). After the power spectral density of the raw EEG data has been extracted from an epoch, each band is analyzed for its DF and APDP. The DF is the frequency with the greatest power over its full-width at half-maximum (FWHM) band. The APDP is the average power of the DF over the FWHM band. The figure below illustrates the concept of dominant frequencies and FWHM bands.

![Alt text](DFAPDP.png?raw=true "DF and APDP Visualized.")

### Power Ratios
The literature indicates that the power ratio (theta + alpha)/beta, as well as the power in the theta band, are linked to fatigue detection. Both the power ratio and theta power are included in the feature vector for each EEG channel.

## Model Evaluation
Training data gathered from individuals in a rested and fatigued state was used to evaluate the feature selection. An SVM was trained on the data and evaluated with out-of-sample data (20% hold-out). A peak accuracy of 92% was observed. This data consists of all the EEG data randomly shuffled together. To see how the model behaves on a subject-to-subject basis, all epochs from an entire subject were witheld from training and used as a measure of generalization error. The model averaged 80% accuracy on an individual subject.

### Tuning the Model
The length of a single sample of raw EEG data (epoch length) may be treated as a hyperparameter of the model. Variations in epoch length have an effect on classification accuracy; however, its effect is less impactful than the length of the feature vector. The figure below shows how the generalization error changes with both epoch length and number of features. The feature "salience" was determined by a neighbourhood component analysis on the feature space. On the graph below, features are added in order of descending NCA weight (saliency).


![Alt text](NEWESTnewSURF copy.png?raw=true "Model accuracy with number of features and length of epoch.")
