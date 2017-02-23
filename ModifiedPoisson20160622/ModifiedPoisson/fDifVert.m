% fDifVert calcuates the forward vertical diference
%
% fv = fDifVert(X)
%Output parameters:
% fv: forward vertical diference
%
%
%Input parameters:
% X: input image
%
%
%Example:
% img = double(imread('img.png'));
% fv = fDifVert(img);
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
function fv = fDifVert(X)

Kv = [ 0;-1; 1 ];
fv = imfilter(X,Kv,'replicate');

