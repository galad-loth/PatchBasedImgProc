clear; close all;clc
img=imread('E:\DevProj\_Datasets\Denoising\color\bird.png');
[nrow, ncol, nchl]=size(img);
verbose=true;

img=double(img);
signa_noise=25;
img_noise=img+signa_noise*randn([nrow, ncol, nchl]);

img=img/256;
img_noise=img_noise/256;
img_gf=ImgFiltering(img_noise,'gaussian', 5, 1.5);
figure;set(gcf, 'position',[400, 100, 800, 800])
subplot(2,2,1);imagesc(img);colormap(gray);title('Clean image')
subplot(2,2,2);imagesc(img_noise);colormap(gray);title('Noise image')
subplot(2,2,3);imagesc(img_gf);title('Gaussian filtering image')
pause(0.05)

if (verbose)
    disp('Training dictionary...');
end

patch_size=13;
pad_flag=0;
crop_type='rand';
num_patch=15000;
corr_gamma=1.5;
patch_size_sq=patch_size*patch_size;
proj_mat=zeros(patch_size_sq*nchl,patch_size_sq*nchl);
for i=1:nchl
    idx_range=((i-1)*patch_size_sq+1):i*patch_size_sq;
    proj_mat(idx_range,idx_range)=1;
end
proj_mat=eye(patch_size_sq*nchl)...
    +corr_gamma/patch_size_sq*proj_mat;
train_data=PatchExtraction(img_noise, patch_size, pad_flag, crop_type, num_patch);
train_data=proj_mat*train_data;
% train_data=bsxfun(@minus, train_data, mean(train_data,1));

train_params.K=256;
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
params.beta=0.25; % weight of the reconstructed image
params.batch_size=10000;
params.verbose=verbose;
params.sc_method='omp';
params.proj_mat=proj_mat;
if strcmp(params.sc_method, 'lasso')
    params.lambda=0.4;%L1 penalty
else
    params.lambda=5;%L0 penalty
end
img_denoise=ColorDenoisingBySC(img_noise, params);
img_denoise(img_denoise<0)=0;
img_denoise(img_denoise>1)=1;
subplot(2,2,4);imagesc(img_denoise);title('SC denoising image')

figure(2);displayPatches(dict);title('Learned dictionary'); 
pause(0.05)