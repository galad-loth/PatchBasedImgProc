function imgst=TSST_PerformST(data, params)
imgst=data.imgc_pyd{params.num_level};
imgst=TSST_AddNoise(imgst, params.std_noise);
imgst=imgst/255;

for i=1:params.num_level   
    imgs=data.imgs_pyd{params.num_level-i+1}/255;
    imgc=data.imgc_pyd{params.num_level-i+1}/255;
    seg_mask=data.mask_pyd{params.num_level-i+1};
    imgc_weight=params.imgc_weight(i);
    [nr, nc, nd]=size(imgc);
    [nrs, ncs, nds]=size(imgc);    
    seg_mask=repmat(seg_mask, [1,1, nd]);
    for j=1:params.num_patch_size
        patch_size=params.patch_size(j);
        if (params.verbose)
            disp(['TSST, level ', num2str(i), ', patch_size ', num2str(patch_size)])
        end
        patch_num=min(params.patch_num, floor(nrs*ncs/patch_size));
        style_patch=PatchExtraction(imgs, patch_size, 0, 'rand', patch_num);
        imgst=TSST_PatchMatchAndAggr(imgst, style_patch, j, params);
        if (params.save_inter_result)
            imwrite(uint8(imgst*255), ['aggr_result_l', num2str(i),'_p', num2str(patch_size),'.png']);
        end
        
        imgst=(imgst+imgc.*seg_mask*imgc_weight)./(1+seg_mask*imgc_weight);
        imgst=imhistmatch(imgst, imgs);
%         imgst=Denoising(imgst, params);
        if (params.save_inter_result)
            imwrite(uint8(imgst*255), ['st_result_l', num2str(i),'_p', num2str(patch_size),'.png']);
        end
    end 
    if (i<params.num_level)
        [nr, nc, nd]=size(data.imgc_pyd{params.num_level-i});
        imgst=imresize(imgst, [nr, nc]); 
    end
end
imgst=uint8(imgst*255);