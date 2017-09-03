function img_out=ANR_Reconstruct(img_lr, feat_lr, dict, projmats, params)
[nrow, ncol]=size(img_lr);
nrow_hr=params.sr_scale*nrow;
ncol_hr=params.sr_scale*ncol;
stride=params.sr_stride;
patch_size_lr=params.patch_size_lr;
patch_size_hr=patch_size_lr*params.sr_scale;
patch_size_feat=patch_size_lr*params.lr_feat_scale;
dim_hr=patch_size_hr*patch_size_hr;
dim_feat=patch_size_feat*patch_size_feat*params.lr_feat_nchl;

img_out=imresize(img_lr,[nrow_hr, ncol_hr]);
aggr_times=ones(nrow_hr, ncol_hr);

dict_lr=dict.dict_lr;
dict_lr=bsxfun(@rdivide, dict_lr, sqrt(sum(dict_lr.^2, 1)));

for nrlu=1:stride:nrow-patch_size_lr
    disp(['Local Optimizing, row', num2str(nrlu)])
    nrlu1=nrlu*params.sr_scale;
    nrlu2=nrlu*params.lr_feat_scale;
    for nclu=1:stride:ncol-patch_size_lr
        nclu1=nclu*params.sr_scale;
        nclu2=nclu*params.lr_feat_scale;
        patch_hr=img_out(nrlu1:nrlu1+patch_size_hr-1, nclu1:nclu1+patch_size_hr-1);
        patch_lr=img_lr(nrlu:nrlu+patch_size_lr-1, nclu:nclu+patch_size_lr-1);
        local_mean=mean(patch_lr(:));
        
        patch_feat=feat_lr(nrlu2:nrlu2+patch_size_feat-1,nclu2:nclu2+patch_size_feat-1,:);
        aggr_times_local=aggr_times(nrlu1:nrlu1+patch_size_hr-1, nclu1:nclu1+patch_size_hr-1);
        
        patch_feat_norm=patch_feat(:)/sqrt(sum(patch_feat(:).^2));
        idx_nn=SearchNN(dict_lr, patch_feat_norm, 1, 'corr');
        
        patch_recov=projmats(:,:,idx_nn)*patch_feat(:)/dim_feat;
        patch_recov=reshape(patch_recov, [patch_size_hr, patch_size_hr])*dim_hr+local_mean;
        patch_recov=(patch_recov+patch_hr.*aggr_times_local)./(1+aggr_times_local);
        aggr_times_local=aggr_times_local+1;
        aggr_times(nrlu1:nrlu1+patch_size_hr-1, nclu1:nclu1+patch_size_hr-1)=aggr_times_local;
        img_out(nrlu1:nrlu1+patch_size_hr-1, nclu1:nclu1+patch_size_hr-1)=patch_recov;        
    end
end
