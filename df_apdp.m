function [df_ind, apdp] = df_apdp(S, inds)
% df_apdp finds the Dominant Frequency (DF) and the Average Power of the
% Dominant Peak (APDP) features from a given frequency range.
% Input:
    % S - one-sided approximate power spectral density of signal.
    % inds - range of indices to perform feature extraction on.
% Output:
    % df_ind - Dominant frequency index. This is defined as the frequency 
    %      with the highest average power in its fwhm band. The index where
    %      this frequency is located is returned for parsing.
    % apdp - Average power of dominant frequency.

% Average power for full-width at half-maximum (fwhm) band of each index.
pwr_max = 0;
ind_max = 0;
for i = 1 : length(inds)
    ind = inds(i);
    hm = S(ind) / 2; % Set the new half-max.
    % Find lower index.
    ind_lo = ind;
    while 1
        ind_lo = ind_lo - 1;
        if(S(ind_lo) <= hm)
            break
        end
        if(S(ind_lo) > S(ind))
            ind_lo = ind_lo + 1;
            break
        end
    end

    % Find high index.
    ind_hi = ind;
    while 1
        ind_hi = ind_hi + 1;
        if(S(ind_hi) <= hm)
            break
        end
        if(S(ind_hi) > S(ind))
            ind_hi = ind_hi - 1;
            break
        end
    end
    % Calculate power in this fwhm.
    d = ind_lo : ind_hi;
    pwr = mean(S(d));
    if pwr > pwr_max
        pwr_max = pwr;
        ind_max = ind;
    end
end
df_ind = ind_max;
apdp = pwr_max;
end