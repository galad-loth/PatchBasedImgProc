function img_data=JDSR_PreProcess(img, params)
img_ds=ImgDownSample(img, params.blur_kernel, params.sr_scale);
[nrow, ncol, nchl]=size(img_ds);
if (nchl==3)
    img_hr=rgb2ycbcr(img);
    img_lr=rgb2ycbcr(img_ds);
    img_hr=double(img_hr(:,:,1));
    img_lr=double(img_lr(:,:,1));
else
    img_hr=double(img);
    img_lr=double(img_ds);
end
nchl_feat=length(params.lr_filters);
img_rs=imresize(img_lr, params.lr_feat_scale);
[nr, nc]=size(img_rs);
feat_lr=zeros(nr, nc, nchl_feat);
for i=1:nchl_feat
    feat_lr(:,:,i)=conv2(img_rs, params.lr_filters{i}, 'same');
end
img_data=struct('img_ori', img, 'img_ds', img_ds, 'img_hr', img_hr,'img_lr', img_lr, 'feat_lr', feat_lr);



function img_ds=ImgDownSample(img, blur_kernel, scale)
if isinteger(img)
    img=double(img);
end
if size(img,3)==1
    img_blur=conv2(img,blur_kernel,'same');
else
    img_blur=zeros(size(img));
    for i=1:size(img, 3)
        img_blur(:,:,i)=conv2(img(:,:,i),blur_kernel,'same');
    end
end
img_ds=imresize(img_blur, 1/scale);
img_ds=uint8(img_ds);

