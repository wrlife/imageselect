% Feature2Img extracts img information from feature data
%
% img = Feature2Img(F)
%Output parameters:
% img: image
%
%
%Input parameters:
% F: Feature
%
%
%Example:
% X = double(imread('img.png'));
% F = imGradFeature(X);
% img = Feature2Img(F);
% 
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
function img = Feature2Img(F)
img = F(:,:,:,1);

