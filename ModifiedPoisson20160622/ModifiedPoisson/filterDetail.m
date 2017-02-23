function dst = filterDetail(src, sigma, alpha, gain, ep)

if( ~exist('alpha', 'var') || isempty(alpha) )
 alpha = -1;
end

if( ~exist('gain', 'var') || isempty(gain) )
 gain = 1;
end

if( ~exist('ep', 'var') || isempty(ep) )
 ep = 1E-8;
end

cha = size(src,3);

if( cha == 1 )
 gry = src;
elseif( cha == 3 )
 gry = 0.299 * src(:,:,1) + 0.587 * src(:,:,2) + 0.114 * src(:,:,3);
else
 gry = mean( src, 3 );
end
gry = gry + 1;% to avoid dividing by zero

crm = bsxfun(@rdivide, src, gry);

fet = imGradFeature( gry );
amp = ( 1 + alpha * exp( -fet(:,:,:,2:end) .* fet(:,:,:,2:end) / (2*sigma*sigma) ) ) * gain;
fet(:,:,:,2:end) = fet(:,:,:,2:end) .* amp;

gry = modPoisson(fet, ep );
gry = gry -1;

dst = bsxfun(@times, crm, gry);
