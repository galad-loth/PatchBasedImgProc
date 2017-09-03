function img_out=JDSR_LocalSolve( img_lr, feat_lr, dict, params)
[nrow, ncol]=size(img_lr);
nrow_hr=params.sr_scale*nrow;
ncol_hr=params.sr_scale*ncol;
stride=params.sr_stride;
patch_size_lr=params.patch_size_lr;
patch_size_hr=patch_size_lr*params.sr_scale;
patch_size_feat=patch_size_lr*params.lr_feat_scale;
dim_hr=patch_size_hr*patch_size_hr;
dim_feat=patch_size_feat*patch_size_feat*params.lr_feat_nchl;

img_out=imresize(img_lr,[nrow_hr, ncol_hr]);%zeros(nrow_hr, ncol_hr);
aggr_times=zeros(nrow_hr, ncol_hr);


for nrlu=1:stride:nrow-patch_size_lr
    disp(['Local Optimizing, row', num2str(nrlu)])
    nrlu1=nrlu*params.sr_scale;
    nrlu2=nrlu*params.lr_feat_scale;
    for nclu=1:stride:ncol-patch_size_lr
        nclu1=nclu*params.sr_scale;
        nclu2=nclu*params.lr_feat_scale;
        patch_lr=img_lr(nrlu:nrlu+patch_size_lr-1, nclu:nclu+patch_size_lr-1);
        local_mean=mean(patch_lr(:));
        patch_hr=img_out(nrlu1:nrlu1+patch_size_hr-1, nclu1:nclu1+patch_size_hr-1);        
        patch_feat=feat_lr(nrlu2:nrlu2+patch_size_feat-1,nclu2:nclu2+patch_size_feat-1,:);   
        aggr_times_local=aggr_times(nrlu1:nrlu1+patch_size_hr-1, nclu1:nclu1+patch_size_hr-1);
        
        idx_nnz=patch_hr(:)~=0;
        patch_hr_data=(patch_hr(:)-mean(patch_hr(idx_nnz)))/dim_hr;
        patch_feat=patch_feat(:)/dim_feat;
        
        patch_data=[patch_hr_data(idx_nnz); patch_feat];
        dict_temp=cat(1, dict.dict_hr(idx_nnz,:), dict.dict_lr);
        if strcmp(params.train_method, 'omp')
            alpha=mexOMP(patch_data, dict_temp,params.solve_param);
        elseif  strcmp(params.train_method, 'lasso')
            alpha=mexLasso(patch_data, dict_temp,params.solve_param);
        end
        patch_recov=dict.dict_hr*full(alpha);
        patch_recov=reshape(patch_recov, [patch_size_hr, patch_size_hr])*dim_hr+local_mean;
        patch_recov=(patch_recov+patch_hr.*aggr_times_local)./(1+aggr_times_local);
        aggr_times_local=aggr_times_local+1;
        aggr_times(nrlu1:nrlu1+patch_size_hr-1, nclu1:nclu1+patch_size_hr-1)=aggr_times_local;
        img_out(nrlu1:nrlu1+patch_size_hr-1, nclu1:nclu1+patch_size_hr-1)=patch_recov;
    end
end



