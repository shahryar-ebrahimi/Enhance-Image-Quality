function [ TR ] = fcn_refine_transmission(I, trans_map, r, N )


    mean_I = boxfilter(I, r) ./ N;
    mean_II = boxfilter(I.*I, r) ./ N;

    var_I = mean_II - mean_I .* mean_I;
    mean_t = boxfilter(trans_map, r) ./ N;
    mean_It = boxfilter(I.*trans_map, r) ./ N;
    cov_It = mean_It - mean_I .* mean_t; % this is the covariance of (I, p) in each local patch.
    at = cov_It ./ (var_I + 0.00001);
    bt = mean_t - at.* mean_I;
    mean_at = boxfilter(at, r) ./ N;
    mean_bt = boxfilter(bt, r) ./ N;
    TR = mean_at .* I + mean_bt;

end

