% Image Segmentation Using MRF with Simulated Annealing
disp('loading image');
image = imread('../test1.bmp');

image = image(:,:,1) ;
image = im2double(image) ;

lcount = 3 ;

disp('setting class statistics');
mu = zeros(lcount,1);
sigma = zeros(lcount,1) + 0.125 ;
mu = [0;0.5;1];

W0 = randi(3,size(image,1), size(image,2));

disp('Start ');
T0 = 1000 ;
T = T0;
Tsigma = -10;
MR = 1;%Modification Ratio
MRsigma = -0.0005;
Beta = 0.2 ;

image = imnoise(image,'gaussian' , 0 , 0.1);
figure ;
title('MRF_input');
imshow(image);
figure;
title('MRF_Res');

for k = 1 : 100
    W = W0;
    rand_locations = zeros(floor(MR*size(W0,1)^2) , 2);
    rand_locations(:,1) = floor(randi(size(W0,1),floor(MR*size(W0,1)^2) , 1));
    rand_locations(:,2) = floor(randi(size(W0,2),floor(MR*size(W0,1)^2) , 1));
        imshow(mat2gray(W0));
        pause(0.1);
        counter = 0 ;
        disp('\n');
        for rli = 1:size(rand_locations,1)
            if(mod(rli,1000)==0)
                fprintf('%d|%d|%d,' , k,rli/1000,floor(size(rand_locations,1)/1000));
            end
            x = rand_locations(rli,1);
            y = rand_locations(rli,2);
            [~,W(x,y)] = max([normpdf(image(x,y),mu(1),sigma(1)),normpdf(image(x,y),mu(2),sigma(2)),normpdf(image(x,y),mu(3),sigma(3))]);
%             W(x,y) = randi(3);
            if( k > 40 )
            while(W(x,y)==W0(x,y))
                W(x,y) = randi(3);
            end
            end
            old_coeff = get_coeff(W0,x,y) ;
            delta_coeff = get_coeff(W,x,y) - old_coeff;
            deltaU = normpdf(image(x,y),mu(W(x,y)),sigma(W(x,y))) - normpdf(image(x,y),mu(W0(x,y)),sigma(W0(x,y)));
            deltaU = deltaU + delta_coeff * Beta ;
            if(deltaU > 0)
                W0 = W;
            else
                p = rand(1);
                threshold = exp(deltaU/T);
                if(p<threshold)
                    W0 = W ;
                end
            end
        end
    
    T = max(Tsigma * k + T0,0.1)  ;
    MR = max(MRsigma * k + MR,0.005) ;
%     if(U == oldU)
%         break;
%     end
end

imshow((W0./3));
disp('finished');




