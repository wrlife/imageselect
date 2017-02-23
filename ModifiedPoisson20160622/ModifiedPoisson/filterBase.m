function dst = filterBase( src, sigma, itr, ep0, ep1 )

if ~exist('itr', 'var') || isempty(itr)
 itr = 4;
end

if ~exist('ep0', 'var') || isempty(ep0)
 ep0 = 1;
end

if ~exist('ep1', 'var') || isempty(ep1)
 ep1 = 1e-8;
end

param = buildModPoissonParam( size(src) );
dst = src;
cha = size(src,3);
if( itr > 1 )
    r = power( ep1 / ep0, 1/(itr-1) );
else
    r = 1;
end
ep = ep0;
for i=1:itr
    fet = imGradFeature( dst );
    grad = fet(:,:,:,2:end);
    gg = grad .* grad;
    gg = sum(gg,3);
    amp = 1 - exp( -gg / (2*sigma*sigma) );
    amp = repmat(amp, [1, 1, cha]);
    grad = grad .* amp;
    
    fet(:,:,:,1) = src;
    fet(:,:,:,2:end) = grad;
    
    dst = modPoisson( fet, param, ep );
    ep = ep * r;
end

