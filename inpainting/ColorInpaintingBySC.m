function img_out=ColorInpaintingBySC(img_in, params)

[nrow, ncol, nchl]=size(img_in);
img_out=zeros(nrow, ncol, nchl);

img_mask=params.img_mask;

stride=params.stride;
patch_size=params.patch_size;
dict=params.dict;
% proj_mat=params.proj_mat;
dict_rev=dict;

if strcmp(params.sc_method, 'lasso')
    sc_params.mode=0;
    sc_params.lambda=params.lambda;
else
    sc_params.L=params.lambda;
end

aggr_times=zeros(nrow, ncol);
for nrlu=1:stride:(nrow-patch_size+1)
    if (params.verbose)
        disp(['Sparse coding based inpainting, processling line ', num2str(nrlu)]);
    end
    for nclu=1:stride:(ncol-patch_size+1)
        local_patch=img_in(nrlu:nrlu+patch_size-1, nclu:nclu+patch_size-1,:);
        local_mask=img_mask(nrlu:nrlu+patch_size-1, nclu:nclu+patch_size-1);
%         local_aggrtimes=aggr_times(nrlu:nrlu+patch_size-1,nclu:nclu+patch_size-1);
        local_patch_proj=local_patch(:);
        local_mask=repmat(local_mask,[1,1, nchl]);
        local_validflag=(local_mask(:)~=0);
        local_signal=sum(local_validflag);
        
        local_dict=dict(local_validflag, :);
        w_norm_dict=1./sqrt(eps+diag(local_dict'*local_dict)); 
        local_dict=local_dict*diag(w_norm_dict);
        
        if strcmp(params.sc_method, 'lasso')
            alpha=mexLasso(local_patch_proj(local_validflag), local_dict,sc_params);
        else
            alpha=mexOMP(local_patch_proj(local_validflag), local_dict ,sc_params);
        end
         local_patch_recov=dict_rev*(w_norm_dict.*full(alpha));
         local_patch_recov=reshape(local_patch_recov, [patch_size, patch_size, nchl]);       
         img_out(nrlu:nrlu+patch_size-1, nclu:nclu+patch_size-1,:)=...
             img_out(nrlu:nrlu+patch_size-1, nclu:nclu+patch_size-1,:)+...
             local_patch_recov*local_signal;
         aggr_times(nrlu:nrlu+patch_size-1,nclu:nclu+patch_size-1)=...
             aggr_times(nrlu:nrlu+patch_size-1,nclu:nclu+patch_size-1)+local_signal;      
    end 
end

img_out=img_out./(eps+repmat(aggr_times,[1,1,nchl]));


