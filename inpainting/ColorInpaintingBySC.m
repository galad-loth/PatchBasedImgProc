function img_out=ColorInpaintingBySC(img_in, params)

[nrow, ncol, nchl]=size(img_in);
img_out=zeros(nrow, ncol,nchl);
aggr_times=zeros(nrow, ncol);
img_mask=params.img_mask;

stride=params.stride;
patch_size=params.patch_size;
dict=params.dict;
proj_mat=params.proj_mat;
dict_rev=dict;

if strcmp(params.sc_method, 'lasso')
    sc_params.mode=0;
    sc_params.lambda=params.lambda;
else
    sc_params.L=params.lambda;
end

for nrlu=1:stride:(nrow-patch_size+1)
    if (params.verbose)
        disp(['Sparse coding based inpainting, processling line ', num2str(nrlu)]);
    end
    for nclu=1:stride:(ncol-patch_size+1)
        patch_data=img_in(nrlu:nrlu+patch_size-1, nclu:nclu+patch_size-1,:);
        mask_data=img_mask(nrlu:nrlu+patch_size-1, nclu:nclu+patch_size-1);
        patch_data_proj=patch_data(:);
        mask_data=repmat(mask_data,[1,1, nchl]);
        mask_flag=(mask_data(:)~=0);
        if (sum(mask_flag)==nchl*patch_size*patch_size)
            patch_data_recov=patch_data;
        else
            if strcmp(params.sc_method, 'lasso')
                alpha=mexLasso(patch_data_proj(mask_flag), dict(mask_flag,:),sc_params);
            else
                alpha=mexOMP(patch_data_proj(mask_flag), dict(mask_flag,:),sc_params);
            end
            patch_data_recov=dict_rev*full(alpha);
%             patch_data_recov(mask_flag)=patch_data(mask_flag);
        end
        img_out(nrlu:nrlu+patch_size-1,nclu:nclu+patch_size-1,:)=...
            img_out(nrlu:nrlu+patch_size-1,nclu:nclu+patch_size-1,:)...
            +reshape(patch_data_recov,[patch_size, patch_size, nchl]);
        aggr_times(nrlu:nrlu+patch_size-1,nclu:nclu+patch_size-1)=...
            aggr_times(nrlu:nrlu+patch_size-1,nclu:nclu+patch_size-1)+1;        
    end
end

img_out=img_out./(eps+repmat(aggr_times,[1,1,nchl]));

