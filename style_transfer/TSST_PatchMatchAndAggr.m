function  imgout=TSST_PatchMatchAndAggr(imgin, style_patch, idx_patch_size, params)

[nrow, ncol, nchl]=size(imgin);

patch_size=params.patch_size(idx_patch_size);
stride=params.stride(idx_patch_size);
batch_size=params.nn_batchsize;
r=params.r;

nrow_lu=1:stride:(nrow-patch_size+1);
ncol_lu=1:stride:(ncol-patch_size+1);
[ncol_lu, nrow_lu]=meshgrid(ncol_lu, nrow_lu);
nrow_lu=nrow_lu(:);
ncol_lu=ncol_lu(:);

patch_num=length(nrow_lu);
batch_num=1;
if patch_num>batch_size
    batch_num=ceil(patch_num/batch_size);
end

imgout=imgin;
for iter=1:params.iter_irls    
    if (params.verbose)
        disp(['IRSL iteration ', num2str(iter)])
    end
    img_temp=zeros(nrow, ncol, nchl);
    aggr_weight=zeros(nrow, ncol);
    for idx_batch=1:batch_num
        idx_patch=(idx_batch-1)*batch_size+1:min(patch_num,idx_batch*batch_size);
        batch_data=PatchExtraction(imgout, patch_size, 0, 'fixloc',nrow_lu(idx_patch),ncol_lu(idx_patch));
        dist_mat=pdist2(batch_data', style_patch');
        [dist_sort, idx_sort]=sort(dist_mat, 2,'ascend');
        for i=1:length(idx_patch)
            nrlu=nrow_lu(idx_patch(i));
            nclu=ncol_lu(idx_patch(i));
            idxnn=idx_sort(i,1);
            weightnn=(eps+dist_sort(i,1)).^(r-2);
            img_temp(nrlu:nrlu+patch_size-1,nclu:nclu+patch_size-1,:)=...
               img_temp(nrlu:nrlu+patch_size-1,nclu:nclu+patch_size-1,:)...
                 +weightnn*reshape(style_patch(:,idxnn),[patch_size, patch_size, nchl]);
             aggr_weight(nrlu:nrlu+patch_size-1,nclu:nclu+patch_size-1)=...
                aggr_weight(nrlu:nrlu+patch_size-1,nclu:nclu+patch_size-1)+weightnn;        
        end
    end
    aggr_weight=repmat(aggr_weight,[1,1,nchl]);
    imgout=img_temp./(aggr_weight+eps);
end



