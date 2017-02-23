img = double(imread('girl.png'));

crr = filterDarkCrr( img, 25 );
imwrite(uint8(crr), 'DarkCrr.png' );

bas = filterBase( img, 12 );
imwrite(uint8(bas), 'Base.png');

enc = filterEnhance( img, 1.5, 12 );
imwrite(uint8(enc), 'Enhance.png' );

det = filterDetail( img, 5, -1 );
imwrite(uint8(det), 'Detail1.png' );

det = filterDetail( img, 5, +1 );
imwrite(uint8(det), 'Detail2.png' );
