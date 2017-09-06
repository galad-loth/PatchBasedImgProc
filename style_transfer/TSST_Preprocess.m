function data=TSST_Preprocess(img1, img2, params)
[nrowc, ncolc, nchlc]=size(img1);
if isempty(params.seg_mask_file)
    seg_mask=ones(nrowc, ncolc);
else
    seg_mask=load(params.seg_mask_file);
    if size(seg_mask,1)~=nrowc || size(seg_mask, 2)~=ncolc
        error('Size of segmentation mask is different from the size of content image')
    end
end
imgc=img1;
imgs=img2;

img1=imhistmatch(img1,img2);
imgc_pyd=BiuldGaussianPyramid(img1,params.num_level, params.sigma_pyd);
imgs_pyd=BiuldGaussianPyramid(img2,params.num_level, params.sigma_pyd);
mask_pyd=BiuldGaussianPyramid(seg_mask,params.num_level, 0.01);

data.imgc=imgc;
data.imgs=imgs;
data.seg_mask=seg_mask;
data.imgc_pyd=imgc_pyd;
data.imgs_pyd=imgs_pyd;
data.mask_pyd=mask_pyd;



