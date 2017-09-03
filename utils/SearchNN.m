function idx_nn=SearchNN(data, anchor, num_nn, metric)
if size(data, 1)~=size(anchor,1) || size(anchor, 2)~=1
    error('Dimensionality mismatch')
end
num_data=size(data,2);

if strcmp(metric, 'corr')
    corr=anchor'*data;
    [corr_sort, idx_sort]=sort(corr);
    idx_nn=idx_sort(num_data:-1:num_data-num_nn+1);
elseif strcmp(metric, 'eucl')
    dist=pdist2(data', anchor','euclidean');
    [dist_sort, idx_sort]=sort(dist);
    idx_nn=idx_sort(1:num_nn);
end