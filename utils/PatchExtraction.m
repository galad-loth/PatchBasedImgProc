function patch_data=PatchExtraction(img, patch_size, pad_flag, crop_type, varargin)
img_pad=img;
patch_size_half=floor(patch_size/2);
if pad_flag==1
    img_pad=padarray(img,[patch_size_half, patch_size_half],0, 'both');
end
[nrow, ncol, nchl]=size(img_pad);

nrow_lu_max=nrow-patch_size+1;
ncol_lu_max=ncol-patch_size+1;

if strcmp(crop_type,'rand')
    patch_num=varargin{1};
    patch_data=zeros(patch_size*patch_size*nchl,patch_num);
    for idx_patch=1:patch_num
        nrow_lu=randi(nrow_lu_max);
        ncol_lu=randi(ncol_lu_max);
        cur_patch=img_pad(nrow_lu:nrow_lu+patch_size-1,ncol_lu:ncol_lu+patch_size-1,:);
        patch_data(:,idx_patch)=cur_patch(:);
    end    
elseif strcmp(crop_type, 'regular')
    stride=varargin{1};    
    nrow_lu=1:stride(1):nrow_lu_max;
    ncol_lu=1:stride(2):ncol_lu_max;
    patch_num=length(nrow_lu)*length(ncol_lu);
    patch_data=zeros(patch_size*patch_size*nchl, patch_num);
    for i=1:length(nrow_lu)
        for j=1:length(ncol_lu)
            idx_patch=j+(i-1)*length(ncol_lu);
            cur_patch=img_pad(nrow_lu(i):nrow_lu(i)+patch_size-1, ncol_lu(j):ncol_lu(j)+patch_size-1,:);
            patch_data(:, idx_patch)=cur_patch(:);
        end
    end
elseif strcmp(crop_type, 'fixloc')
    nrow_lu=varargin{1};
    ncol_lu=varargin{2};
    if length(nrow_lu)~=length(ncol_lu)
        error('nrow_lu and ncol_lu must have the same length')
    end
    patch_num=length(nrow_lu);
    patch_data=zeros(patch_size*patch_size*nchl, patch_num);
    for i=1:patch_num
        cur_patch=img_pad(nrow_lu(i):nrow_lu(i)+patch_size-1, ncol_lu(i):ncol_lu(i)+patch_size-1,:);
        patch_data(:,i)=cur_patch(:);
    end
else
    error('Unkown Crop Type.');
end
