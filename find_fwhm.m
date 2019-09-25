function [pk, d, ind, pwr] = find_fwhm(S)
% Input: one-sided frequency spectrum signal S.
% Output:
%        pk - max amplitude of data.
%        d  - width of fwhm band (single number).
[pk, ind] = max(S); % Get max value and location.
hm = pk / 2; % Half-max.

% Find lower index.
ind_lo = ind;
while 1
    ind_lo = ind_lo - 1;
    if(S(ind_lo) < hm)
        break
    end
end

% Find high index.
ind_hi = ind;
while 1
    ind_hi = ind_hi + 1;
    if(S(ind_hi) < hm)
        break
    end
end

% Find the width of the fwhm band.
d = ind_hi - ind_lo;

% Find the power in the fwhm band.
pwr = sum(S(ind_lo : ind_hi).^2)/d;
end