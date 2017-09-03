function img_out=JDSR_GlobalSolve(img_sr, img_lr, params)
[nrow1, ncol1]=size(img_sr);
[nrow2, ncol2]=size(img_lr);

img_out=img_sr;
for i=1:params.glbopt_iter
    img_ds=imresize(img_out, [nrow2, ncol2]);
    diff1=img_ds-img_lr;
    diff2=img_out-img_sr;
    diff1=imresize(diff1,[nrow1, ncol1]);
    img_out=img_out-params.glbopt_tau*(diff1+params.glbopt_lambda*diff2);    
end
