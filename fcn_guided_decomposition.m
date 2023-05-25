function [ base_layer, detail_layer, amb_map, mean_I, var_I, N, residual_img ] = fcn_guided_decomposition(I, p, r, eps)

[hei, wid] = size(I);
detail_layer = zeros(size(I));

N = boxfilter(ones(hei, wid), r); % the size of each local patch; N=(2r+1)^2 except for boundary pixels.
% N = colfilt(ones(hei, wid), [2*r+1, 2*r+1], 'sliding', @sum);

mean_I = boxfilter(I, r) ./ N;
% mean_I = colfilt(I, [2*r+1, 2*r+1], 'sliding', @sum)./N;
mean_p = boxfilter(p, r) ./ N;
% mean_p = colfilt(p, [2*r+1, 2*r+1], 'sliding', @sum)./N;
mean_Ip = boxfilter(I.*p, r) ./ N;
% mean_Ip = colfilt(I.*p, [2*r+1, 2*r+1], 'sliding', @sum)./N;
cov_Ip = mean_Ip - mean_I .* mean_p; % this is the covariance of (I, p) in each local patch.

mean_II = boxfilter(I.*I, r) ./ N;
var_I = mean_II - mean_I .* mean_I;

% decomposition process
q{1} = I;
for i = 1:length(eps)
    a = cov_Ip ./ (var_I + eps(i));
    b = mean_p - a .* mean_I;
    mean_a{i} = boxfilter(a, r) ./ N;
    mean_b{i} = boxfilter(b, r) ./ N;
   
    q{i+1} = mean_a{i} .* I + mean_b{i};
    residual_img{i} = q{i} - q{i+1};
    %superposition of residual layer + sigmoid function
    detail_layer = detail_layer + fcn_mapping(residual_img{i}, 0); 

end

base_layer = q{end};
amb_map = mean_b{end};

end

