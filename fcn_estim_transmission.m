function [trans_map] = fcn_estim_transmission(img, A, step_size)

[hei, wid, ~] = size(img);
trans_map = zeros(hei, wid);
num_chan = size(img,3);

for i = 1:step_size:size(img,1)
    for j = 1:step_size:size(img,2)
        end_i = i + step_size-1; end_j = j + step_size-1;
        if end_i > size(img,1)
            end_i = size(img,1);
        end
        if end_j > size(img,2)
            end_j = size(img,2);
        end
        trans_list = 0.2:0.05:1.0;
        
        sub_img = img(i:end_i, j:end_j, :);
        
        % tmin calculation
        under_lim = zeros(1, num_chan);
        over_lim =  zeros(1, num_chan);
        for c = 1:num_chan
            sub_img_chan = sub_img(:,:,c);
            sub_img_arr = sub_img_chan(:);
            sub_img_diff = sub_img_arr - A(c);
            sub_img_under = sub_img_diff(sub_img_diff < 0);
            sub_img_over = sub_img_diff(sub_img_diff > 0);
            [under_val, ~] = max(sub_img_under);
            [over_val, ~] = min(sub_img_over);
            
            
            under_val = under_val + A(c);
            over_val = over_val + A(c);
            
            if ~isempty(under_val)
                under_lim(c) = (A(c) - under_val) / A(c);
            else
                under_lim(c) = trans_list(1);
            end
            
            if ~isempty(over_val)
                over_lim(c) = (over_val - A(c)) / (1 - A(c));
            else
                over_lim(c) = trans_list(1);
            end
        end
        
        lower_limit = max([under_lim over_lim]);
        if (lower_limit < trans_list(1))
            lower_limit = trans_list(1);
        end
        trans_list = lower_limit:0.1:1;
        
        if isempty(trans_list)
            trans_list = lower_limit;
        end
        
        % maximaize the cost function
        cost_list = zeros(size(trans_list));
        cont_list = zeros(size(trans_list));
        loss_list = zeros(size(trans_list));
        
        for t = 1:length(trans_list)
            trans = trans_list(t);
            sub_res = zeros(size(sub_img));
            e_cont = zeros(1, num_chan);
            e_loss = zeros(1, num_chan);
            for c = 1:num_chan
                sub_res(:,:,c) = (sub_img(:,:,c) - A(c)) ./ trans + A(c);
                
                sub_res_chan = sub_res(:,:,c);
                e_cont(c) = std(sub_res_chan(:)); %subimage contrast
                %subimage loss information
                e_loss(c) = (sum(abs(sub_res_chan(sub_res_chan > 1))) + sum(abs(sub_res_chan(sub_res_chan < 0)))) ./ numel(sub_res_chan);
                
            end
            e_cont = sum(e_cont);
            e_loss = sum(e_loss);
            cont_list(t) = e_cont;
            loss_list(t) = e_loss;
            cost_list(t) = e_cont - e_loss;
        end
        [~, min_idx] = max(cost_list);
        
        trans_val = trans_list(min_idx)+0.1;        
        
        [sub_hei, sub_wid,~] = size(sub_img);
        trans_map(i:end_i, j:end_j) = trans_val * ones(sub_hei, sub_wid);
        
    end
end
end

