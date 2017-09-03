clear;close all; clc
params=ANR_SetParams();

img=imread(params.test_img);
[nrow, ncol, nchl]=size(img);
img_data=JDSR_PreProcess(img, params);
img_us=imresize(img_data.img_ds, params.sr_scale);
figure(1);set(gcf,'position',[200 100 900 800])
subplot(2,2,1);imagesc(img_data.img_ori);colormap(gray);title('high resolution image')
subplot(2,2,2);imagesc(img_data.img_ds);colormap(gray);title('low resolution image')
subplot(2,2,3);imagesc(img_us);colormap(gray);title('upscale image by interpolation')
pause(0.05)

disp('Training dictionary...')
dict=JDSR_Train(params);
projmats=ANR_ComputeProjMat(dict.dict_hr, dict.dict_lr, params);
img_sr=ANR_Reconstruct(img_data.img_lr, img_data.feat_lr, dict, projmats, params);

if (nchl==3)
    img_sr=GetSRColorImage(img_sr, img_data.img_ds);
end
subplot(2,2,4);imagesc(img_sr);title('super-resolution image')