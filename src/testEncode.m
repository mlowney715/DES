% DES debug test script
% Prints every intermediate step of the DES algorithm

clear;clc

Key =  ...
    '0000000100100011010001010110011110001001101010111100110111101111'-'0';
M = Key;
C = DES(M, Key, 1, true);