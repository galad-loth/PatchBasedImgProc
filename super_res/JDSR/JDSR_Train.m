function dict_out=JDSR_Train(params)
if ~isempty(params.dict_file)
    load(params.dict_file);
    dict_out=dict;
    return;
end
traindata_dir=params.traindata_dir;
patch_num=params.patch_num;
sr_scale=params.sr_scale;

[traindata_list,num_train_img]=CleanFileList(dir(traindata_dir), {'.png','.bmp','.jpg','.jpeg'});
sample_num=floor(patch_num/num_train_img);
patch_num=sample_num*num_train_img;

patch_size_hr=params.patch_size_lr*sr_scale;
patch_size_lr=params.patch_size_lr*params.lr_feat_scale;
dim_hr=patch_size_hr*patch_size_hr;
dim_lr=patch_size_lr*patch_size_lr*params.lr_feat_nchl;
train_data=zeros(dim_lr+dim_hr, patch_num);

for idx_img=1:num_train_img
    img=imread([params.traindata_dir, traindata_list(idx_img).name]);
    img_data=JDSR_PreProcess(img, params);
    train_data_sub=CollectTrainData(img_data, sample_num, dim_hr, dim_lr, params);   
    train_data(:,(idx_img-1)*sample_num+1:idx_img*sample_num)=train_data_sub;    
end

dict=mexTrainDL(train_data,params.train_param);
dict_out.dict_hr=dict(1:dim_hr, :);
dict_out.dict_lr=dict(dim_hr+1:end, :);

function collect_data=CollectTrainData(img_data, sample_num, dim_hr, dim_lr, params)

patch_size_lr=params.patch_size_lr;
[nrow, ncol]=size(img_data.img_lr);

nrlu_lr=randi(nrow-patch_size_lr-1, 1,sample_num);
nclu_lr=randi(ncol-patch_size_lr-1, 1,sample_num);
nrlu_hr=nrlu_lr*params.sr_scale;
nclu_hr=nclu_lr*params.sr_scale;
nrlu_lr=nrlu_lr*params.lr_feat_scale;
nclu_lr=nclu_lr*params.lr_feat_scale;
patch_size_hr=patch_size_lr*params.sr_scale;
patch_size_lr=patch_size_lr*params.lr_feat_scale;

patch_data_hr=PatchExtraction(img_data.img_hr, patch_size_hr, 0, 'fixloc', nrlu_hr,nclu_hr);
patch_data_hr=bsxfun(@minus, patch_data_hr, mean(patch_data_hr, 1));
patch_data_lr=PatchExtraction(img_data.feat_lr, patch_size_lr, 0, 'fixloc', nrlu_lr,nclu_lr);
collect_data=cat(1, patch_data_hr/dim_hr,patch_data_lr/dim_lr);


