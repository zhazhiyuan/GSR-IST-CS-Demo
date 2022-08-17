clc;

clear;

close all;

filename      =      'House256';

Subrate       =       0.3;

if Subrate ==0.1
    
p        =      0.65; 

mu       =      0.5;

elseif Subrate==0.2
    
p        =      0.5; 

mu       =      0.3;

elseif Subrate==0.3
    
p        =      0.95; 

mu       =      1.5;

else
    
p        =      0.95; 

mu       =      1.5;

end

im_out   =     GSR_IST_CS_Main(filename,Subrate,mu,p);

imshow(im_out,[]);

imwrite(uint8(im_out),'House_ratio_0.3.png');

