function C = DES( M, Key, op, debug )
%C = DES(M,KEY, OP) DES encryption/decryption algorithm
%   C = DES(M, Key, 1) 
%       Encrypt plaintext M with Key
%   C = DES(M, Key, 2)
%       Decode encrypted code M with Key

% TODO!!!
%   Debug flag - if on go through 1 round and print intermediate results
%       of encryption and then decryption
%   Document and annotate code
%   Include URL of paper and anything else that helped me along the way

if nargin == 3
    debug = false;
elseif nargin ~= 4
    error('Please enter 3 or 4 arguments')      
end

if debug
   disp('Plaintext (M):')
   disp(num2str(M));
   disp('Key (K):')
   disp(num2str(Key)); 
end

% Generate 16 different keys.
K = roundkeygen(Key, debug);

% Initial Permutation.
IP = PC1(M);

% Use the keys to do the actual encryption of the permuted text.
if op == 1
    [L, R] = scramble(IP, K);
    if debug
        L0 = IP(1:32);
        R0 = IP(33:64);
        KR = double(xor(E(R0), (K(1, :))));
        RK = f(R0, K(1, :));
        disp('L0:')
        disp(num2str(L0));
        disp('R0:')
        disp(num2str(R0))
        disp('E(R0):')
        disp(num2str(E(R0)))
        disp('A = E[R0] xor K1:')
        disp(num2str(KR))
        disp('B = Sboxes(A):')
        disp(num2str(sbox(KR)))
        disp('P(B):')
        disp(num2str(RK))
        disp('R1:')
        disp(num2str(R(1, :)))
        disp('L1:')
        disp(num2str(L(1, :)))
        disp('Result:')
        disp([num2str(R(1, :)) '  ' num2str(L(1, :))])
    end
else
    [L, R] = unscramble(IP, K);
end

% Perform the final permutation to return encrypted C.
C = PC16(L, R);

end

function IP = PC1(K)
perm = [ ...
    58  50  42  34  26  18  10  2   ...
    60  52  44  36  28  20  12  4   ...
    62  54  46  38  30  22  14  6   ...
    64  56  48  40  32  24  16  8   ...
    57  49  41  33  25  17  9   1   ...
    59  51  43  35  27  19  11  3   ...
    61  53  45  37  29  21  13  5   ...
    63  55  47  39  31  23  15  7];

IP = PC(perm, K);

end

function [L, R] = scramble(IP, K)
L0 = IP(1:32);
R0 = IP(33:64);

L(1, :) = R0;

RK = f(R0, K(1, :));

R(1, :) = double(xor(L0,RK));

for i = 2:16
    L(i, :) = R(i-1, :);
    RK = f(R(i-1, :), K(i, :));
    R(i, :) = xor(L(i-1, :),RK);
end
end

function [L, R] = unscramble(IP, K)
L0 = IP(1:32);
R0 = IP(33:64);

L(1, :) = R0;

RK = f(R0, K(16, :));

R(1, :) = double(xor(L0,RK));

for i = 2:16
    L(i, :) = R(i-1, :);
    RK = f(R(i-1, :), K(17-i, :));
    R(i, :) = xor(L(i-1, :),RK);
end
end

function R_48 = E(R)
perm = [ ...
    32  1   2   3   4   5   ...
    4   5   6   7   8   9   ...
    8   9   10  11  12  13  ...
    12  13  14  15  16  17  ...
    16  17  18  19  20  21  ...
    20  21  22  23  24  25  ...
    24  25  26  27  28  29  ...
    28  29  30  31  32  1];

R_48 = PC(perm, R);
end

function InvIP = PC16(L, R)

perm = [ ...
    40     8   48    16    56   24    64   32   ...
    39     7   47    15    55   23    63   31   ...
    38     6   46    14    54   22    62   30   ...
    37     5   45    13    53   21    61   29   ...
    36     4   44    12    52   20    60   28   ...
    35     3   43    11    51   19    59   27   ...
    34     2   42    10    50   18    58   26   ...
    33     1   41     9    49   17    57   25];

InvIP = PC(perm, R(16, :), L(16, :));

end

function result = f(R, K)
KR = double(xor(K, E(R)));
S = sbox(KR);
perm = [ ...
    16  7   20  21  29  12  28  17  ...
    1   15  23  26  5   18  31  10  ...
    2   8   24  14  32  27  3   9   ...
    19  13  30  6   22  11  4   25];
result = PC(perm, S);
end

