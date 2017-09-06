function img_pyd=BiuldGaussianPyramid(img, level, xigma)
if isinteger(img)
    img=double(img);
end
win_size=round(6*xigma)+1;
img_pyd=cell(1, level);
img_pyd{1}=img;
for k=2:level
    imgk=ImgFiltering(img_pyd{k-1}, 'gaussian', win_size, xigma);
    img_pyd{k}=imresize(imgk, 0.5);
end