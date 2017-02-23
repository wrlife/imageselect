function [dst base detail] = filterEnhance( src, alpha, sigma, itr, ep0, ep1 )

if ~exist('itr', 'var') || isempty(itr)
 itr = 4;
end

if ~exist('ep0', 'var') || isempty(ep0)
 ep0 = 1;
end

if ~exist('ep1', 'var') || isempty(ep1)
 ep1 = 1e-8;
end

base = filterBase( src, sigma, itr, ep0, ep1 );
detail = src - base;

base = base / alpha + (255-255/alpha)/2;
detail = detail * alpha;
dst = base + detail;
