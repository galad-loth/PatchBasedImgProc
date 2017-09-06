clear;close all;clc
params=TSST_SetParameters();
img1=imread(params.content_img);
img2=imread(params.style_img);
figure(1);set(gcf, 'position',[200, 100, 1200, 800])
subplot(2,2,1);imagesc(img1);title('content image')
subplot(2,2,2);imagesc(img2);title('style image')

data=TSST_Preprocess(img1, img2, params);
subplot(2,2,3);imagesc(data.seg_mask);title('segmantation mask')
imgst=TSST_PerformST(data, params);
subplot(2,2,4);imagesc(uint8(imgst));title('style transfer image')