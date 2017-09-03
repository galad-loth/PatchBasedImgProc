function params=ANR_SetParams()
params.traindata_dir='E:\DevProj\_Datasets\SuperResolution\SR_training_datasets\T91\';
params.test_img='E:\DevProj\_Datasets\SuperResolution\SR_testing_datasets\Set5\GT\butterfly.png';
params.sr_scale=3;
params.sr_stride=1;
params.blur_kernel=fspecial('gaussian',3,1.2);
params.patch_size_lr=5;% patch_size in low-resolution image
params.dict_size=512;
params.patch_num=12000;
params.dict_file='dict_jdsr';
params.lr_filters={[1, 0, -1],[1; 0; -1], [1, 0, -2, 0, 1], [1; 0; -2; 0; 1]};
params.lr_feat_nchl=length(params.lr_filters);
params.lr_feat_scale=2;

params.train_method='omp';
if strcmp(params.train_method, 'omp')
    params.train_param.K=params.dict_size;
    params.train_param.mode=3;
    params.train_param.lambda=10;
    params.train_param.iter=100;
    % params.solve_param.mode=3;
%     params.solve_param.L=10;
elseif  strcmp(params.train_method, 'lasso')
    params.train_param.K=params.dict_size;
    params.train_param.mode=0;
    params.train_param.lambda=0.8;
    params.train_param.iter=100;
%     params.solve_param.mode=0;
%     params.solve_param.lambda=0.8;
end

params.proj_lambda=0.001;
params.vec_projmat_file=[];
params.nn_num=10;
params.nn_metric='corr';
params.comb_weight=0.75;