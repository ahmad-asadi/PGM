%Segmentation using naive bayes classifier

disp('loading image');
simage = imread('../test1.bmp');

simage = simage(:,:,1);
%simage = rgb2gray(simage);
orig_image = simage;
figure;
imhist(simage);

noise_mean = 0 ;
noise_variance = 0.1 ;

g0 = 0 ;
g1 = 0 ;
g2 = 0 ;

for i = 1 : 417
    for j = 1:415
        if(simage(i,j) == 0)
            g0 = g0 +1 ;
        elseif(simage(i,j)==127)
            g1 = g1 + 1 ;
        else
            g2 = g2 + 1 ;
        end
    end
end

sg = g0+g1+g2 ;

g0 = g0/sg ;
g1 = g1/sg ;
g2 = g2/sg ;



simage = imnoise(simage,'gaussian', noise_mean,noise_variance);
figure;
title('noisy_input');
image = double(simage);
imshow(mat2gray(image));

disp('adding gaussian noise with mean = 0 and var= 0.01 to the image');
noisy_image = image;
% noisy_image = imnoise(noisy_image, 'gaussian' , noise_mean , noise_variance);

% imshow(mat2gray(noisy_image));
% figure;

mu0 = 0 ;
mu1 = 127 ;
mu2 = 200 ;

%mu0 = 20 ;
%mu1 = 80 ;
%mu2 = 160 ;

%sigma = 15 ;
sigma = 32;

posteriors = zeros(417, 415, 3) ;


for i = 1 : size(noisy_image,1)
    fprintf('calculating posterior probs for i: %d\n' , i);
    for j = 1 : size(noisy_image,2)
        posteriors(i,j,1) = normpdf(noisy_image(i,j),mu0,sigma) * g0;
        posteriors(i,j,2) = normpdf(noisy_image(i,j),mu1,sigma) * g1;
        posteriors(i,j,3) = normpdf(noisy_image(i,j),mu2,sigma) * g2;
    end
end

res = zeros(size(posteriors,1),size(posteriors,2)) - 1;
for i = 1 : size(posteriors,1)
    fprintf('calculating MLE for i: %d\n' , i);
    for j = 1 : size(posteriors,2)
        [~,res(i,j)] = max(posteriors(i,j,:));
        if(res(i,j)==1)
            res(i,j) = 0;
        elseif(res(i,j)==2)
            res(i,j) = 127;
        elseif(res(i,j)==3)
            res(i,j) = 255;
        end
    end
end

figure;
title('final_result');
imshow(mat2gray(res));



figure;
title('difference');
imshow(mat2gray(double(orig_image) - res*255/3));



