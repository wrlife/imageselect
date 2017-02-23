function dst = filterToneCurve( src, toneFunc, ep )
if ~exist('ep', 'var') || isempty(ep)
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
amp = toneFunc( gry ) ./ gry;
amp = repmat( amp, [1, 1, size(fet,3), size(fet,4)]);
fet = fet .* amp;

gry = modPoisson(fet, ep );
gry = gry -1;

dst = bsxfun(@times, crm, gry);
