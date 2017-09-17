# PatchBasedImgProc

patch based image processing, include denosing, super-resolution, inpainting and style transfer, etc. The purpose is for my self-education of those fileds.

# Denoising

A simple implementation of the sparse representation based methods.

![Gray Image Denosing Example](https://github.com/galad-loth/ImageRecovTrans/blob/master/data/Gray%20Denoising%20Result.png)

![Color Image Denosing Example](https://github.com/galad-loth/ImageRecovTrans/blob/master/data/Color%20Denoising%20Result.png)

# Super-resolution

Two methods are tried: sparse representation/anchor neighborhood regression with jointly learned dictionary .

![Super-Resolution Example](https://github.com/galad-loth/ImageRecovTrans/blob/master/data/Super-resolution%20result.png)

# Inpainting
Currently, only sparse coding base inpainting method is implemented, which can restore images patially corrupted by random noise or thin-structrures(e.g., text).

![Random-Occlusion Inpainting Example](https://github.com/galad-loth/ImageRecovTrans/blob/master/data/Inpainting%20Result-Random%20Occlusion%20.png)

![Text Removal Example](https://github.com/galad-loth/ImageRecovTrans/blob/master/data/Inpainting%20Result-Text%20Mask.png)

It is also intended to try exempler based inpainting method in future. 

# style transfer

It is intended to implement the style-transfer methods proposed recently by Michael Elad and Peyman Milanfar, which is a non-CNN based method.

# References

1. Elad M, Aharon M. Image denoising via sparse and redundant representations over learned dictionaries[J]. IEEE Transactions on Image processing, 2006, 15(12): 3736-3745.

2. Yang J, Wright J, Huang T, et al. Image super-resolution as sparse representation of raw image patches[C]//Computer Vision and Pattern Recognition, 2008. CVPR 2008. IEEE Conference on. IEEE, 2008: 1-8.

3. Yang J, Wright J, Huang T S, et al. Image super-resolution via sparse representation[J]. IEEE transactions on image processing, 2010, 19(11): 2861-2873.

4. Timofte R, De Smet V, Van Gool L. Anchored neighborhood regression for fast example-based super-resolution[C]//Proceedings of the IEEE International Conference on Computer Vision. 2013: 1920-1927.

5. Barnes C, Shechtman E, Finkelstein A, et al. PatchMatch: A randomized correspondence algorithm for structural image editing[J]. ACM Trans. Graph., 2009, 28(3): 24:1-24:11.

6. Korman S, Avidan S. Coherency sensitive hashing[C]//Computer Vision (ICCV), 2011 IEEE International Conference on. IEEE, 2011: 1607-1614.

7. Arias P, Facciolo G, Caselles V, et al. A variational framework for exemplar-based image inpainting[J]. International journal of computer vision, 2011, 93(3): 319-347.

8. Liu Y, Caselles V. Exemplar-based image inpainting using multiscale graph cuts[J]. IEEE transactions on image processing, 2013, 22(5): 1699-1711.

9. Elad M, Milanfar P. Style Transfer Via Texture Synthesis[J]. IEEE Transactions on Image Processing, 2017, 26(5): 2338-2351.
