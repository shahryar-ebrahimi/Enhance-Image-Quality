function [ out_I, base_layer,trans_map, trans_map_refine, A ,amb_map,amb_row,amb_col] = fcn_multiscale_enhancement( I, p, box_size, scale_smooth, scale_mapping)

%   Input arguments:

%	- I : guidance image
%   - p : filtering input image
%	- scale_smooth : predifined smoothing factors (epsilon)
%   - box_size: size of default box for filtering

%% Preallocation
n_channel = size(I,3);
out_I = zeros(size(I));
base_layer = zeros(size(I));
detail_layer = zeros(size(I));
amb_map = zeros(size(I));
mean_I = zeros(size(I));
var_I = zeros(size(I));

%% Guided-filtering based decomposition
for i = 1:n_channel
    [base_layer(:,:,i), detail_layer(:,:,i), amb_map(:,:,i), mean_I(:,:,i), var_I(:,:,i), N] = .... 
        fcn_guided_decomposition(I(:,:,i), p(:,:,i), box_size, scale_smooth);
end

%% Intensity Module

% ambient light estimation
[A, amb_row,amb_col] = fcn_estim_ambient(I, amb_map);

% transmission estimation
trans_map = fcn_estim_transmission(base_layer, A, box_size);


%% Laplacian Module 
if size(I,3) == 3
    guide_I = rgb2gray(base_layer);
else
    guide_I = base_layer;
end

% transmission refinement
trans_map_refine = fcn_refine_transmission(guide_I, trans_map, box_size, N);
       

%% Color correction
if n_channel == 3
    if std(A) >  0.2 %sigma threshold
        disp ('Color biased');
        AB = norm(A)*ones(size(A)) ./ sqrt(3); % AB = balanced ambient light
    else
        AB = A;
    end
else
    AB = A;
end


%% Reconstruction
J = zeros(size(out_I));
for i = 1:n_channel
    J(:,:,i) = (base_layer(:,:,i) - A(i))./trans_map_refine + AB(i);
    out_I(:,:,i) = J(:,:,i) + detail_layer(:,:,i);
end

end



