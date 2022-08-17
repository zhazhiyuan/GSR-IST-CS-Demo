
function Reconstructed_image        =           GSR_IST_CS(Y, par,p)

Row                 =                    par.Row;

Col                 =                    par.Col;

PHI                 =                    par.PHI;

X_org               =                    par.Org;

mu                  =                    par.mu;

IterNum             =                    par.IterNum;

X_Initial           =                    par.Initial;

patch_size          =                    par.patch_size;

X                   =                    im2col(X_Initial, [patch_size patch_size], 'distinct');

ATA                 =                     PHI'*PHI;

ATy                 =                     PHI'*Y;

All_PSNR = zeros(1,IterNum);

for j = 1:IterNum

    z               =                    col2im(X, [patch_size patch_size],[Row Col], 'distinct');  
    
    X_BAR           =                    GSR_IST_GST(z, par,p);  % Eq.(18)
    
    X_BAR           =                    im2col(X_BAR, [patch_size patch_size], 'distinct');
    
    X               =                    X_BAR+  mu*( ATy  -  ATA* X_BAR); %Eq.(11)

    X_IMG           =                    col2im(X, [patch_size patch_size],[Row Col], 'distinct');
    
    All_PSNR(j)     =                    csnr(X_IMG,X_org,0,0);
    
    fprintf('IterNum = %d, PSNR = %f, FSIM = %f\n',j,csnr(X_IMG,X_org,0,0),FeatureSIM(X_IMG,X_org));
    
    if j>1
        if (All_PSNR(j)-All_PSNR(j-1)<0)
            break;
        end
    end
    
end


Reconstructed_image = X_IMG;

fprintf('The proposed CS recovery: PSNR = %f, FSIM = %f\n',csnr(Reconstructed_image,X_org,0,0),FeatureSIM(Reconstructed_image,X_org));

end

