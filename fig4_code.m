clc
clearvars
close all

img = im2double(imread('input images\fattal\road_input.png'));
n_channel = size(img,3);
r = 20;
eps = [1e-4, 1e-3, 1e-2]; 

for i = 1:n_channel
[ base_layer(:,:,i), ~, amb_map(:,:,i), ~, ~, N, ~ ] = ...
fcn_guided_decomposition(img(:,:,i), img(:,:,i), r, eps);
end

[A, amb_row_base, amb_col_base] = fcn_estim_ambient(base_layer, amb_map);
trans_map_baselyer = fcn_estim_transmission(base_layer, A, r);
TR_baselayer = fcn_refine_transmission(rgb2gray(base_layer), trans_map_baselyer, r, N );

[A, amb_row_img, amb_col_img] = fcn_estim_ambient(img, amb_map);
trans_map_img = fcn_estim_transmission(img, A, r);
TR_img = fcn_refine_transmission(rgb2gray(img), trans_map_img, r, N );


 AI_img = img(amb_row_img, amb_col_img);
 AI_baselayer = base_layer(amb_row_base, amb_col_base);
 
 amb_map_mean = mean(amb_map,3);
I_amb = img; 
I_amb(amb_row_img,amb_col_img,1) = 1;
I_amb(amb_row_img,amb_col_img,2) = 0;
I_amb(amb_row_img,amb_col_img,3) = 0;

I_amb_base = base_layer; 
I_amb_base( amb_row_base, amb_col_base,1) = 1;
I_amb_base( amb_row_base, amb_col_base,2) = 0;
I_amb_base( amb_row_base, amb_col_base,3) = 0;

imwrite(I_amb,'results\fig4(a).png')
imwrite(I_amb_base,'results\fig4(b).png')
imwrite(AI_img,'results\fig4(c).png')
imwrite(AI_baselayer,'results\fig4(d).png')

 figure;imshow(I_amb);title('input image')
 figure; imshow(AI_img);title('ambient light using input image')
 figure; imagesc(TR_img);title('transmission map using input image')
  figure;imshow(I_amb_base);title('base layer')
 figure; imshow(AI_baselayer);title('ambient light using base layer')
 figure; imagesc(TR_baselayer);title('transmission map using base layer')
 figure;imshowpair(AI_img,AI_baselayer,'diff')
 
 