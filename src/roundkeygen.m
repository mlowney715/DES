function K = roundkeygen( K_64, debug )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

if nargin == 1
    debug = false;
elseif nargin ~= 2
    error('Please enter one or two arguments')
end

perm = [ ...
    57  49  41  33  25  17  9   1 ...
    58  50  42  34  26  18  10  2 ...
    59  51  43  35  27  19  11  3 ...
    60  52  44  36  63  55  47  39 ...
    31  23  15  7   62  54  46  38 ...
    30  22  14  6   61  53  45  37 ...
    29  21  13  5   28  20  12  4];

PC1 = PC(perm, K_64);

perm = [ ...
    14  17  11  24  1   5   3   28  ...
    15  6   21  10  23  19  12  4   ...
    26  8   16  7   27  20  13  2   ...
    41  52  31  37  47  55  30  40  ...
    51  45  33  48  44  49  39  56  ...
    34  53  46  42  50  36  29  32];

C0 = PC1(1:28);
D0 = PC1(29:56);

K = zeros(16, 48);

C(1, :) = circshift(C0, [0, -1]);
D(1, :) = circshift(D0, [0, -1]);
K(1, :) = PC(perm, C(1, :), D(1, :));

if debug
    disp('PC-1:')
    disp(num2str(PC1));
    disp('C1:')
    disp(num2str(C(1, :)));
    disp('D1:')
    disp(num2str(D(1, :)));
    disp('PC-2:')
    disp(num2str(K(1, :)));
end

for i = 2:16
    if i == 2 || i == 9 || i == 16
        C(i, :) = circshift(C(i-1, :), [0, -1]);
        D(i, :) = circshift(D(i-1, :), [0, -1]);
    else
        C(i, :) = circshift(C(i-1, :), [0, -2]);
        D(i, :) = circshift(D(i-1, :), [0, -2]);
    end
    K(i, :) = PC(perm, C(i, :), D(i, :));
end

end

