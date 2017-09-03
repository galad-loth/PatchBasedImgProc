function projmats=ANR_ComputeProjMat(dict_hr, dict_lr,params)
[dim_hr, num_atom_hr]=size(dict_hr);
[dim_lr, num_atom_lr]=size(dict_lr);
if num_atom_hr~=num_atom_lr
    error('The high- and low-resolution dictionaries must have the same number of atoms');
end
dict_full=cat(1, dict_hr, dict_lr);

regmat=params.proj_lambda*eye(params.nn_num);
projmats=zeros(dim_hr, dim_lr, num_atom_hr);
for i=1:num_atom_hr
    idx_nn=SearchNN(dict_full,dict_full(:,i), params.nn_num+1, params.nn_metric);
    idx_nn=idx_nn(2:end);
    temp=dict_lr(:,idx_nn)'*dict_lr(:,idx_nn)+regmat;
    projmats(:,:,i)=(dict_hr(:,idx_nn)/temp)*dict_lr(:,idx_nn)';
end

