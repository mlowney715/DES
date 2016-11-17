function choice = PC( perm, K, K2 )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if nargin == 3
    K = [K K2];
end

choice = zeros(1, length(perm));
for i = 1:length(perm)
    choice(i) = K(perm(i));
end

end

