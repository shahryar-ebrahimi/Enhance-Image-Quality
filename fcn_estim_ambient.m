function [ A , amb_row,amb_col] = fcn_estim_ambient( I, amb_map )
% Function for ambient light estimation

n_channel = size(I, 3);
amb_map = mean(amb_map, 3);
A = zeros(1, n_channel);
hei = size(I,1);
amb_num = floor(0.001 * numel(amb_map)); % 0.1 percent
[~, max_ind] = sort(amb_map(:), 'descend');
max_ind = max_ind(1:amb_num);
amb_row = mod(max_ind , hei)+1;
amb_col = floor(max_ind/hei)+1;
% compute ambient light for each channel
for c = 1:n_channel
    I_each = I(:,:,c); % each channel
    A(c) = median(I_each(max_ind));
    
end

end

