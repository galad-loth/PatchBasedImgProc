function img_out=ColorDenoisingBySC(img_in, params)

[nrow, ncol, nchl]=size(img_in);
img_out=zeros(nrow, ncol,nchl);
aggr_times=zeros(nrow, ncol);

stride=params.stride;
patch_size=params.patch_size;
batch_size=params.batch_size;
dict=params.dict;
proj_mat=params.proj_mat;
dict_rev=proj_mat\dict;

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

if strcmp(params.sc_method, 'lasso')
    sc_params.mode=0;
    sc_params.lambda=params.lambda;
else
    sc_params.L=params.lambda;
end

for idx_batch=1:batch_num
    if (batch_num>1 && params.verbose)
        disp(['Batch processing: ', num2str(idx_batch),'/', num2str(batch_num)]);
    end
    idx_patch=(idx_batch-1)*batch_size+1:min(patch_num,idx_batch*batch_size);
    batch_data=PatchExtraction(img_in, patch_size, 0, 'fixloc',nrow_lu(idx_patch),ncol_lu(idx_patch));
    batch_data=proj_mat*batch_data;
%     batch_mean=mean(batch_data, 1);
%     batch_data=bsxfun(@minus, batch_data, batch_mean);
%     batch_norm=sqrt(sum(batch_data.*batch_data,1));
%     batch_data=bsxfun(@times,batch_data, 1./(batch_norm+eps));
    if strcmp(params.sc_method, 'lasso')
         alpha=mexLasso(batch_data, dict,sc_params);
    else
         alpha=mexOMP(batch_data, dict,sc_params);
    end
    batch_data=dict_rev*full(alpha);
%     batch_data=bsxfun(@times,batch_data, batch_norm);
%     batch_data=bsxfun(@plus, batch_data,batch_mean);
    for i=1:length(idx_patch)
        nrlu=nrow_lu(idx_patch(i));
        nclu=ncol_lu(idx_patch(i));
        img_out(nrlu:nrlu+patch_size-1,nclu:nclu+patch_size-1,:)=...
            img_out(nrlu:nrlu+patch_size-1,nclu:nclu+patch_size-1,:)...
            +reshape(batch_data(:,i),[patch_size, patch_size, nchl]);
        aggr_times(nrlu:nrlu+patch_size-1,nclu:nclu+patch_size-1)=...
            aggr_times(nrlu:nrlu+patch_size-1,nclu:nclu+patch_size-1)+1;        
    end
end

img_out=img_out./(eps+repmat(aggr_times,[1,1,nchl]));
img_out=(img_out+params.beta*img_in)/(1+params.beta);



