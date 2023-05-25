function [out_img,base_layer, time, trans_map,trans_map_refined, A,amb_map,amb_row,amb_col] = fcn_multi(img)

%   Input arguments:
%	- img : input haze image
% 	- scale_smooth : predifined smoothing factors (epsilon)
%   - box_size: size of default box for filtering
%
%   Output arguments:

%   - out_img: output dehazed image
%   - trans_map: refined transmission map
%   - A: ampbient light


scale_smooth = [1e-4, 1e-3, 1e-2]; 
box_size = 20;
tic;

[out_img,base_layer,trans_map, trans_map_refined, A,amb_map,amb_row,amb_col] = fcn_multiscale_enhancement(img, img, box_size, scale_smooth);
adj_percent = [0.005, 0.995];
out_img = imadjust(out_img, adj_percent);

time = toc;

