function [XrestN, XfatN] = feature_extraction(Data_Pre_t, Data_Post_t, len_epoch)
% This function takes raw 4-channel EEG data and builds feature vectors for
% rested and fatigued data.
% Features:
%   - Dominant Frequency (DF)
%   - Average Power of the Dominant Peak (APDP)
%   - The frequency band power ratio (theta + alpha)/beta
%   - Theta band power
% Uses 4-channel EEG data, computes these features on the delta (0.4-4 Hz),
% theta (4-8 Hz), alpha (8-13 Hz), and beta (13-20 Hz) bands.
%
% Input: 
%   - Data_Pre_t: A cell array of rested data, each element contains a 
%     single EEG trial. Each trial is an Nx4 matrix, where N is the number
%     of samples, and 4 is the number of channels.
%   - Data_Post_t: A cell array of fatigued data, having the same structure
%     as Data_Pre_t.
%   - len_epoch: length of the epoch to be used. should be in number of
%     samples, not seconds. (i.e., (sampling rate) * (epoch length).)
% 
% Output:
%   - XrestN, XfatN: Normalized training data matrices. NxF, where N is the
%     number of samples (epochs), and F is the number of features (40 here).
%     Data matrices are normalized such that variance is 1 and mean is 0
%     over the whole dataset.

num_features = 40;
offset = 256 * 15; % Discard first 15s of data.
len_lag = 256 * 2; % 2s lag between epochs.

% Define frequency ranges for delta, theta, alpha, and beta.
f = 256*(0:(len_epoch/2))/len_epoch;
r_d = 0.4 < f & f < 4;
r_t = 4 < f & f < 8;
r_a = 8 < f & f < 13;
r_b = 13 < f & f < 20;

% Start with rested data.
disp('Extracting epochs from rested data.')
j = 1;
for n = 1 : length(Data_Pre_t)
    sample = Data_Pre_t{n}; % Extract nth sample.
    sample_fil = sample;%bandpass(sample, [0.3 25], 256);
    i = offset + len_epoch;
    while i < length(sample_fil)
        rested{j} = sample_fil(i - len_epoch : i-1,:); % Take 4s of data.
        i = i + len_epoch + len_lag; % Skip over 4s + 2s of data.
        j = j + 1;
    end
end
% Now rested contains sets of 4s epochs.
disp('Extracting features from rested data.')
Xtr_rest = zeros(length(rested), num_features);
for i = 1 : length(rested)
    %FFT the next sample to obtain an approximate power spectral density.
    sample = ssFFT(rested{i});
    for k = 1 : 4
        ch = sample(:,k);
        % In each channel, pull out the DF and APDP for each of the
        % four bands (delta, theta, alpha, and beta.
        
        % Delta.
        ch_d = ch(r_d);
        f_d = f(r_d);
        [df_ind_d, apdp_d] = df_apdp([0 ; ch_d ; 0], (2 : length(ch_d)));
        df_d = f_d(df_ind_d - 1);
        p_d = sum(ch_d);
        
        % Theta.
        ch_t = ch(r_t);
        f_t = f(r_t);
        [df_ind_t, apdp_t] = df_apdp([0 ; ch_t ; 0], (2 : length(ch_t)));
        df_t = f_t(df_ind_t - 1);
        p_t = sum(ch_t);
        
        % Alpha.
        ch_a = ch(r_a);
        f_a = f(r_a);
        [df_ind_a, apdp_a] = df_apdp([0 ; ch_a ; 0], (2 : length(ch_a)));
        df_a = f_a(df_ind_a - 1);
        p_a = sum(ch_a);
        
        % Beta.
        ch_b = ch(r_b);
        f_b = f(r_b);
        [df_ind_b, apdp_b] = df_apdp([0 ; ch_b ; 0], (2 : length(ch_b)));
        df_b = f_b(df_ind_b - 1);
        p_b = sum(ch_b);
        
        ind = 10*(k-1)+1;
        Xtr_rest(i,ind : ind+9) = [df_d apdp_d df_t apdp_t df_a apdp_a df_b apdp_b ((p_a + p_t)/p_b) p_t];
    end
end

% Next, fatigued data.
disp('Extracting epochs from fatigued data.')
j = 1;
for n = 1 : length(Data_Post_t)
    sample = Data_Post_t{n}; % Extract nth sample.
    sample_fil = sample;%bandpass(sample, [0.3 25], 256);
    i = offset + len_epoch;
    while i < length(sample_fil)
        fatigued{j} = sample_fil(i - len_epoch : i-1,:); % Take 4s of data.
        i = i + len_epoch + len_lag; % Skip over 4s + 2s of data.
        j = j + 1;
    end
end
% Now rested contains sets of 4s epochs.
% Define frequency ranges for delta, theta, alpha, and beta.

disp('Extracting features from fatigued data.')
Xtr_fat = zeros(length(fatigued), num_features);
for i = 1 : length(fatigued)
    %FFT the next sample to obtain an approximate power spectral density.
    sample = ssFFT(fatigued{i});
    for k = 1 : 4
        ch = sample(:,k);
        % In each channel, pull out the DF and APDP for each of the
        % four bands (delta, theta, alpha, and beta.
        
        % Delta.
        ch_d = ch(r_d);
        f_d = f(r_d);
        [df_ind_d, apdp_d] = df_apdp([0 ; ch_d ; 0], (2 : length(ch_d)));
        df_d = f_d(df_ind_d - 1);
        p_d = sum(ch_d);
        
        % Theta.
        ch_t = ch(r_t);
        f_t = f(r_t);
        [df_ind_t, apdp_t] = df_apdp([0 ; ch_t ; 0], (2 : length(ch_t)));
        df_t = f_t(df_ind_t - 1);
        p_t = sum(ch_t);
        
        % Alpha.
        ch_a = ch(r_a);
        f_a = f(r_a);
        [df_ind_a, apdp_a] = df_apdp([0 ; ch_a ; 0], (2 : length(ch_a)));
        df_a = f_a(df_ind_a - 1);
        p_a = sum(ch_a);
        
        % Beta.
        ch_b = ch(r_b);
        f_b = f(r_b);
        [df_ind_b, apdp_b] = df_apdp([0 ; ch_b ; 0], (2 : length(ch_b)));
        df_b = f_b(df_ind_b - 1);
        p_b = sum(ch_b);
        
        ind = 10*(k-1)+1;
        Xtr_fat(i,ind : ind+9) = [df_d apdp_d df_t apdp_t df_a apdp_a df_b apdp_b ((p_a + p_t)/p_b) p_t];
    end
end

disp('Normalizing data.')
% Normalize the data.
XM = mean([Xtr_rest ; Xtr_fat]);
XV = var([Xtr_rest ; Xtr_fat]);

XrestN = (Xtr_rest - XM) .* 1 ./ sqrt(XV);
XfatN = (Xtr_fat - XM) .* 1 ./ sqrt(XV);
end