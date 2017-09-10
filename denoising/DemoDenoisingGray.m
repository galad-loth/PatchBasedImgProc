clear;close all;clc
img=imread('E:\DevProj\_Datasets\Denoising\gray\barbara.png');
if (size(img,3)==3)
    img=double(rgb2gray(img));
else
    img=double(img);
end
[nrow, ncol]=size(img);
verbose=true;

signa_noise=15;
img_noise=img+signa_noise*randn([nrow, ncol]);
img_gf=ImgFiltering(img_noise, 'gaussian', 5, 1.5);
figure;set(gcf, 'position',[400, 100, 800, 800])
subplot(2,2,1);imagesc(img,[0 255]);colormap(gray);title('Clean image')
subplot(2,2,2);imagesc(img_noise,[0,255]);colormap(gray);title('Noise image')
subplot(2,2,3);imagesc(img_gf,[0,255]);colormap(gray);title('Gaussian filtering image')
pause(0.05)

if (verbose)
    disp('Training dictionary...');
end
img_noise=img_noise/256;
patch_size=13;
pad_flag=0;
crop_type='rand';
num_patch=10000;
train_data=PatchExtraction(img_noise, patch_size, pad_flag, crop_type, num_patch);
train_data=bsxfun(@minus, train_data, mean(train_data,1));

train_params.K=128;
train_params.mode=3;
train_params.lambda=5;
train_params.iter=150;
dict=mexTrainDL(train_data,train_params);


if (verbose)
    disp('Perform denoising...');
end
params.patch_size=patch_size;
params.dict=dict; 
params.stride=1;
params.beta=0.0; % weight of the reconstructed image
params.batch_size=10000;
params.verbose=verbose;
params.sc_method='omp';
if strcmp(params.sc_method, 'lasso')
    params.lambda=0.4;%L1 penalty
else
    params.lambda=5;%L0 penalty
end
img_denoise=GrayDenoisingBySC(img_noise, params);
img_denoise=img_denoise*256;
subplot(2,2,4);imagesc(img_denoise,[0 255]);colormap(gray);title('SC denoising image')

figure(2);displayPatches(dict);colormap(gray);title('Learned dictionary'); 
pause(0.05)
