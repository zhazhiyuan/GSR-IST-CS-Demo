
function [Imout]             =                   GSR_IST_GST (InputImage, par, p )

 [H, W]                      =                   size(InputImage);

Region                       =                   par.Region;

patch                        =                   par.patch;

Patchsize                    =                   patch*patch;

Similar_patch                =                   par.Similar_patch;

step                         =                   par.step;

N                            =                   H-patch+1;

M                            =                   W-patch+1;

L                            =                   N*M;

row                          =                  [1:step:N];

row                          =                  [row row(end)+1:N];

col                          =                  [1:step:M];

col                          =                  [col col(end)+1:M];

Groupset     =  zeros(Patchsize, L, 'single');

cnt     =  0;

for i  = 1:patch
    for j  = 1:patch
        cnt    =  cnt+1;
        Patch  =  InputImage(i:H-patch+i,j:W-patch+j);
        Patch  =  Patch(:);
        Groupset(cnt,:) =  Patch';
    end
end

GroupsetT               =                 Groupset';

I                       =                 (1:L);

I                       =                 reshape(I, N, M);

NN                      =                 length(row);

MM                      =                 length(col);

Imgtemp                 =                 zeros(H, W);

Imgweight               =                 zeros(H, W);

Array_Patch             =                 zeros(patch, patch, Similar_patch);


for  i  =  1 : NN
    
    for  j  =  1 : MM
        
        currow             =              row(i);
        
        curcol             =              col(j);
        
        off                =              (curcol-1)*N + currow;
        
        Patchindx          =              Similar_Search(GroupsetT, currow, curcol, off, Similar_patch, Region, I);
        
        curArray           =              Groupset(:, Patchindx);
        
        M_temp             =              repmat(mean(curArray,2),1,Similar_patch);
        
        curArray           =              curArray - M_temp;
        
        U_i                =              getsvd(curArray); % generate PCA basis
        
        A0                 =              U_i'*curArray;
        
        s0                 =              mean (A0.^2,2);

        s0                 =              max  (0, s0-par.sigma^2);
        
        LambdaM            =              repmat ( 2*par.sigma^2./(sqrt(s0)+eps),[1, size(A0,2)]); %Generate the weight Eq.(19)
        
        Alpha              =              solve_Lp_w (A0, LambdaM, p);%GST Algorithm  Eq.(18)
        
        curArray           =              U_i*Alpha;
        
        curArray           =              curArray + M_temp;
        
        for k = 1:Similar_patch
            
        Array_Patch(:,:,k) =               reshape(curArray(:,k),patch,patch);
        
        end
        
        for k = 1:length(Patchindx)
            
            RowIndx       =               ComputeRowNo((Patchindx(k)), N);
            
            ColIndx       =               ComputeColNo((Patchindx(k)), N);
            
            Imgtemp(RowIndx:RowIndx+patch-1, ColIndx:ColIndx+patch-1)    =   Imgtemp(RowIndx:RowIndx+patch-1, ColIndx:ColIndx+patch-1) + Array_Patch(:,:,k)';
            
            Imgweight(RowIndx:RowIndx+patch-1, ColIndx:ColIndx+patch-1)  =   Imgweight(RowIndx:RowIndx+patch-1, ColIndx:ColIndx+patch-1) + 1;
            
        end
        
    end
end

Imout = Imgtemp./(Imgweight+eps);

return;


