% fDifHori calcuates the forward horizontal diference
%
% fh = fDifHori(X)
%Output parameters:
% fh: forward horizontal diference
%
%
%Input parameters:
% X: input image
%
%
%Example:
% img = double(imread('img.png'));
% fh = fDifHori(img);
%
%
%Version: 20150310

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modified Poisson                                         %
%                                                          %
% Copyright (C) 2015 Masayuki Tanaka. All rights reserved. %
%                    mtanaka@ctrl.titech.ac.jp             %
%                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fh = fDifHori(X)

Kh = [ 0,-1, 1 ];
fh = imfilter(X,Kh,'replicate');

