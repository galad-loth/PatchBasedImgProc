function img_out=TSST_AddNoise(img_in, xigma)
[nrow, ncol, nchl]=size(img_in);
img_out=img_in+xigma*randn([nrow, ncol, nchl]);
minval=-xigma;
maxval=255+xigma;

for k=1:nchl
    imgk=img_out(:,:,k);
    idx1=imgk<minval;
    idx2=imgk>maxval;
    imgk(idx1)=minval;
    imgk(idx2)=maxval;
    img_out(:,:,k)=(imgk-minval)*255/(maxval-minval);
end


