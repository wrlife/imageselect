% Feature2Grad extracts img information from feature data
%
% [fh fv] = Feature2Grad(F)
%Output parameters:
% fh: forward horizontal difference
% fh: forward horizontal difference
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
function [fh, fv] = Feature2Grad(F)
fh = ( F(:,:,:,2) + circshift(F(:,:,:,4),[0,-1])) / 2;
fv = ( F(:,:,:,3) + circshift(F(:,:,:,5),[-1,0])) / 2;

