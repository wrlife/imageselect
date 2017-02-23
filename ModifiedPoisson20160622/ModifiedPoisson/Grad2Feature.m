% Grad2Feature transforms image data, horizontal and vertical gradient to gradient feature map.
%
% F = Grad2Feature( img, fh, fv )
%Output parameters:
% F(:,:,:,1): intensity
% F(:,:,:,2): forward horizontal diference
% F(:,:,:,3): forward vertical diference
% F(:,:,:,4): backward horizontal diference
% F(:,:,:,5): backward vertical diference
%
%
%Input parameters:
% img: input image
% fh: forward horizontal diference
% fv: forward vertical diference
%
%
%Example:
% img = double(imread('img.png'));
% Kh = [ 0,-1, 1 ];
% Kv = [ 0;-1; 1 ];
% fh = imfilter(img,Kh,'replicate');
% fv = imfilter(img,Kv,'replicate');
% F = Grad2Feature(img, fh, fv);
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
function F = Grad2Feature( img, fh, fv )

s = size(img);
F = zeros(s(1),s(2),s(3),5);

F(:,:,:,1) = img;
F(:,:,:,2) = fh;
F(:,:,:,3) = fv;
F(:,:,:,4) = circshift(F(:,:,:,2),[0,1]);
F(:,:,:,5) = circshift(F(:,:,:,3),[1,0]);
