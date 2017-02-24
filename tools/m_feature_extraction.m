function tmpkeyframe = m_feature_extraction(imgnew,features)

graynew = rgb2gray(imgnew);
if strcmpi(features,'BRISK')
    pointsnew = detectBRISKFeatures(graynew); 
elseif strcmpi(features,'FAST')
    pointsnew = detectFASTFeatures(graynew);
elseif strcmpi(features,'HARRIS')
    pointsnew = detectHarrisFeatures(graynew);
elseif strcmpi(features,'SURF')
    pointsnew = detectSURFFeatures(graynew,'MetricThreshold',100);
end

[featuresnew, pointsnew] = extractFeatures(graynew, pointsnew); 
tmpkeyframe.image = imgnew;
tmpkeyframe.points = pointsnew;
tmpkeyframe.features = featuresnew;