function img_out=GetSRColorImage(img_sr,img_ds)
[nrow1, ncol1]=size(img_sr);

% img_sr=histeq(uint8(img_sr), imhist(img_ds(:,:,1)));
img_us=imresize(img_ds, [nrow1, ncol1]);
img_us=rgb2ycbcr(img_us);
img_sr_min=min(img_sr(:));
img_sr_max=max(img_sr(:));
img_sr=(img_sr-img_sr_min)*img_sr_max/(img_sr_max-img_sr_min);
img_us(:,:,1)=uint8(img_sr);

img_out=ycbcr2rgb(img_us);

