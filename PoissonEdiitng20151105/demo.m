%%%%%%%%%%%%%%%%
% choise = questdlg('The fast version of Poisson reconstruction is available online.', 'Download?', 'Check now!', 'No, thank you.', 'Check now!' );
% switch choise
%  case 'Check now!'
% 	web('http://www.mathworks.com/matlabcentral/fileexchange/39438-fast-seamless-image-cloning-by-modified-poisson-equation');
% end

%%%%%%%%%%%%%%%%

lena = double(imread('lena.png'));
girl = double(imread('girl.png'));

[Lh Lv] = imgrad(lena);
[Gh Gv] = imgrad(girl);

X = lena;
Fh = Lh;
Fv = Lv;

w = 57;
h = 16;
LX = 123;
LY = 125;
GX = 89;
GY = 101;

X(LY:LY+h,LX:LX+w,:) = girl(GY:GY+h,GX:GX+w,:);
Fh(LY:LY+h,LX:LX+w,:) = Gh(GY:GY+h,GX:GX+w,:);
Fv(LY:LY+h,LX:LX+w,:) = Gv(GY:GY+h,GX:GX+w,:);

msk = zeros(size(X));
msk(LY:LY+h,LX:LX+w,:) = 1;

imwrite(uint8(X),'X.png');

tic;
Y = PoissonJacobi( X, Fh, Fv, msk );
toc
imwrite(uint8(Y),'Yjc.png');
tic;
Y = PoissonGaussSeidel( X, Fh, Fv, msk );
toc
imwrite(uint8(Y),'Ygs.png');
