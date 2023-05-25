clearvars;
clc; 
close all;

save_name = 'tiananmen';

img = im2double(imread('input images\fattal\tiananmen.png'));
% g = im2double(imread('input images\Telescope_gt.png'));

[dehazed_img, base_layer, comp_time,trans_map, trans_map_refined,A,...
    amb_map,amb_row,amb_col] = fcn_multi(img);
% PSNR = psnr(dehazed_img,g);
% SSIM = ssim(dehazed_img,g);

figure(1);imshow(img);title('input image')

figure(2);
imshow(base_layer);title('base layer')

amb_map_mean = mean(amb_map,3);
figure(3);
imagesc(amb_map_mean);
colormap jet;title('ambient map')

I_amb = img; 
I_amb(amb_row,amb_col,1) = 1;
I_amb(amb_row,amb_col,2) = 0;
I_amb(amb_row,amb_col,3) = 0;

figure(4);
imshow(I_amb);title('condidated pixels for ambient light')

figure(5);
imagesc(trans_map);title('transmission map (not refined)')

figure(6);
imagesc(trans_map_refined); 
title('transmission map');

figure(7);
imshowpair(img, dehazed_img,'montage');
title('Enhancement result');
 
imwrite(dehazed_img,['results\' save_name '.png'])
