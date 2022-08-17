
function reconstructed_image = GSR_IST_CS_Main(filename, subrate, mu, p)
            
            randn('seed',0);
          
           Original_Filename      =           [filename '.tif'];
           
           Original_Image         =           imread(Original_Filename);
           
           [Row, Col,kkk]         =           size(Original_Image);
        
           if kkk==3
            Original_Image        =           double(rgb2gray(Original_Image));
           else
            Original_Image        =           double((Original_Image));
           end
        
        % Constructe Measurement Matrix (Gaussian Random)
          patch_size              =           32;
          
          NN                      =           patch_size * patch_size;
          
          MM                      =           round(subrate * NN);
          
          PHI                     =           orth(randn(NN, NN))';
          
          PHI                     =           PHI(1:MM, :);
        
          X                       =           im2col(Original_Image, [patch_size patch_size], 'distinct');
        
          Y                       =           PHI * X;  % CS Measurements
        
        fprintf('。。。。。。。。。。。。。。。\n');
        fprintf(filename);
        fprintf('\n');
        fprintf('。。。。。。。。。。。。。。。\n');
        fprintf('rate = %0.2f\n',subrate);
        fprintf('。。。。。。。。。。。。。。。\n');
        
        disp('Using BCS Initilization ...');
        
        [x_MH, ~]                 =          MH_BCS_SPL_Decoder(Y, PHI, subrate, Row, Col);
        
        fprintf('The BCS inital PSNR = %0.2f\n',csnr(x_MH,Original_Image,0,0));
        
        disp('Ending BCS Initilization ...');
        
        par                       =         [];
        
        if ~isfield(par,'PHI')
             par.PHI             =           PHI;
        end
        
        if ~isfield(par,'patch_size')        
             par.patch_size      =           patch_size;
        end
        
       if ~isfield(par,'Row')    
             par.Row             =           Row;
       end
       
       if ~isfield(par,'Col')           
             par.Col             =           Col;
       end
   
       if ~isfield(par,'patch')
            par.patch           =            7; %m
       end  
       
       if ~isfield(par,'mu')
            par.mu              =            mu;%rou
       end
       
       if ~isfield(par,'sigma')
            par.sigma           =            sqrt(2);
       end
        
       if ~isfield(par,'Initial')
            par.Initial         =             double(x_MH);
       end
        
        if ~isfield(par,'Org')        
            par.Org            =              Original_Image;
        end
        
        if ~isfield(par,'IterNum')
            par.IterNum       =               600;
        end
        
        if ~isfield(par,'step')
            par.step          =               4;
        end  
         
         if ~isfield(par,'Similar_patch')
            par.Similar_patch =               60;  %c
         end
         
         if ~isfield(par,'Region')
            par.Region        =              20; % H
         end    


        [reconstructed_image] =              GSR_IST_CS(Y, par,p);

        
end

