function dec = binarray2dec( binarray )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

dec = 0;
c = length(binarray);
for i = 1:c
    dec = dec + binarray(i)*2^(c-i);
end

end
