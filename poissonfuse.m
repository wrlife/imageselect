% [Lh Lv] = imgrad(double(panorama));
% [Gh Gv] = imgrad(double(warpedImage));
% mask=repmat(mask,[1 1 3]);
% X = double(panorama);
% Fh = Lh;
% Fv = Lv;
% 
% tmpI=zeros(size(panorama));
% 
% tmpI(mask==1)=panorama(mask==1);
% 
% mask = (tmpI>0);
% 
% X(mask==1) = warpedImage(mask==1);
% Fh(mask==1) = Gh(mask==1);
% Fv(mask==1) = Gv(mask==1);
% 
% panorama = PoissonGaussSeidel( X, Fh, Fv, double(mask));


mask=repmat(mask,[1 1 3]);

tmpI=zeros(size(panorama));

tmpI(mask==1)=panorama(mask==1);

mask = generatemask(tmpI);

mask=repmat(mask,[1 1 1 5]);

Lf = imGradFeature(double(panorama));
Gf = imGradFeature(double(warpedImage));

Lf(mask==1) = Gf(mask==1);

X = Lf(:,:,:,1);

param = buildModPoissonParam( size(Lf) );
panorama = modPoisson( Lf, param, 1E-8 );


