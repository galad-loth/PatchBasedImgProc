clear; close all;clc
img=imread('E:\DevProj\_Datasets\Denoising\color\bird.png');
[nrow, ncol, nchl]=size(img);
verbose=true;
img=double(img)/256;

img_mask=imread('E:\DevProj\_Datasets\Denoising\color\text_mask.png');
% img_mask=uint8(rand(nrow, ncol)>0.6);
[nrowm, ncolm]=size(img_mask);
if (nrowm>nrow || ncolm>ncol)
    error('The size of mask is larger than the size of image')
else
    img_mask1=uint8(ones(nrow, ncol));
    nrow0=floor(nrow/2-nrowm/2)+1;
    ncol0=floor(ncol/2-ncolm/2)+1;
    img_mask1(nrow0:(nrow0+nrowm-1), ncol0:(ncol0+ncolm-1))=img_mask;
    img_mask=img_mask1;
end

img_corrput=reshape(img,[nrow*ncol, nchl]);
img_corrput(img_mask==0,:)=0;
img_corrput=reshape(img_corrput, [nrow, ncol, nchl]);

figure;set(gcf, 'position',[400, 100, 800, 800])
subplot(2,2,1);imagesc(img);title('Original image')
subplot(2,2,2);imagesc(img_corrput);title('Corrupted image')
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
train_data=PatchExtraction(img, patch_size, pad_flag, crop_type, num_patch);
train_data=proj_mat*train_data;
% train_data=bsxfun(@minus, train_data, mean(train_data,1));

train_params.K=256;
train_params.mode=3;
train_params.lambda=5;
train_params.iter=150;
dict=mexTrainDL(train_data,train_params);
subplot(2,2,3);displayPatches(dict);title('Learned dictionary'); 
pause(0.05)


if (verbose)
    disp('Perform denoising...');
end
params.patch_size=patch_size;
params.dict=dict; 
params.stride=1;
params.verbose=verbose;
params.sc_method='omp';
params.proj_mat=proj_mat;
params.img_mask=img_mask;
if strcmp(params.sc_method, 'lasso')
    params.lambda=0.4;%L1 penalty
else
    params.lambda=5;%L0 penalty
end
img_inpaint=ColorInpaintingBySC(img_corrput, params);
img_inpaint(img_inpaint<0)=0;
img_inpaint(img_inpaint>1)=1;
subplot(2,2,4);imagesc(img_inpaint);title('SC inpainting image')

