lena = double(imread('lena.png'));
girl = double(imread('girl.png'));

Lf = imGradFeature(lena);
Gf = imGradFeature(girl);

w = 57;
h = 16;
LX = 123;
LY = 125;
GX = 89;
GY = 101;

Lf(LY:LY+h,LX:LX+w,:,:) = Gf(GY:GY+h,GX:GX+w,:,:);

X = Lf(:,:,:,1);

param = buildModPoissonParam( size(Lf) );
Y = modPoisson( Lf, param, 1E-8 );

imwrite(uint8(X),'X.png');
imwrite(uint8(Y),'Y.png');

